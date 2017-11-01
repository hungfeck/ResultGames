<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="ResultGame.index" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>VTVCAB</title>
    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Custom fonts for this template -->
    <link rel="stylesheet" href="vendor/font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" href="vendor/simple-line-icons/css/simple-line-icons.css" />
    <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Muli" rel="stylesheet" />

    <!-- Plugin CSS -->
    <link rel="stylesheet" href="device-mockups/device-mockups.css" />

    <!-- Custom styles for this template -->
    <link href="css/new-age.css" rel="stylesheet"/>
    <link href="date/jquery.datetimepicker.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
		<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-app.js"></script>
		<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-auth.js"></script>
		<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-database.js"></script>
		<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-firestore.js"></script>
		<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-messaging.js"></script>
    <script src="date/jquery.datetimepicker.full.js"></script>
</head>
<body id="page-top">
    <form id="form1" runat="server">
   <script>
       var config = {
           apiKey: "AIzaSyBpawnGQ1WPtyOHODWAxuyG9dy9yuUThOY",
           authDomain: "resultsgame.firebaseapp.com",
           databaseURL: "https://resultsgame.firebaseio.com",
           projectId: "resultsgame",
           storageBucket: "resultsgame.appspot.com",
           messagingSenderId: "1080413171479"
       };
       var gameId = "";
       var round = "round1"; // Mặc định hiển thị kết quả Hiệp 1
       var roundTimeMatch = "";
       var defaultApp = firebase.initializeApp(config);
       var defaultDatabase = defaultApp.database();
       var ref = defaultDatabase.ref("games");
       var h1 = document.getElementById('timehome'),
        //  start = document.getElementById('starthome'),
         secondsR1 = 0, minutesR1 = 0, hoursR1 = 0, secondsawayR1 = 0, minutesawayR1 = 0, hoursawayR1 = 0,
         secondsR2 = 0, minutesR2 = 0, hoursR2 = 0, secondsawayR2 = 0, minutesawayR2 = 0, hoursawayR2 = 0,
         secondsmatchR1 = 0, minutesmatchR1 = 0, hoursmatchR1 = 0, secondsmatchR2 = 0, minutesmatchR2 = 0, hoursmatchR2 = 0,
         tR1, tawayR1, tR2, tawayR2, tmatchR1, tmatchR2;
       var finishedR1 = "0", finishedR2 = "0";
       var startedR1 = "0", startedR2 = "0";
       var role = "visitor", user = "", owneruser = "", leagueRound = "1";
       checklogin();
       function checklogin() {
           var params = {};
           $.ajax
           ({
               type: "POST",
               url: "Handlers/CheckLogin.ashx",
               data: params,
               async: false,
               dataType: 'json',
               success: function (data) {
                   if (data != null) {
                       role = data.role;
                       user = data.username;
                       
                   }
                   else {
                       return null;
                   }
               },
               error: function (result) {
                   return null;
               }
           });
       }
    </script>
    <div class="wrapper_add_edit" id="wrapper_add_edit" style="height: 100%; padding-top: 0%">
      <div class="wrapper_form" id="wrapper_form" style="margin-top: 20px;">
          <div class="close" style="padding-right: 10px; cursor: pointer;">
              <h3 style="float: right;">&times;</h3>
          </div>
          <div class="tab">
              <div class="tablinks tablinks_details " onclick="openCity(event, 'round1')" id="defaultOpen"><label for="tab-2" class="defaultlabel">Hiệp 1</label></div>
              <div class="tablinks tablinks_manageUserSale" onclick="openCity(event, 'round2')"><label for="tab-2">Hiệp 2</label></div>
              <div class="tablinks tablinks_manageUserGroup" onclick="openCity(event, 'round3')"><label for="tab-2">Tất cả</label></div>
          </div>
          <div id="round1" class="tabcontent">
            <table style="margin-left: 5%;margin-right: 5%; width: 90%">
                <tr>
                    <td style="width: 10%">Đội nhà</td>
                    <td style="width: 40%"><select class="homeclub club" style="width: 60%;"></select></td>
                    <td style="width: 10%">Đội khách</td>
                    <td style="width: 40%"><select class="awayclub club" style="width: 60%;"></select></td>
                </tr>
              <tr>
                <td style="width: 10%">Sân vận động</td>
                <td style="width: 40%"><select class="stadium" style="width: 60%;"></select></td>
                <td style="width: 10%">Thời gian</td>
                <td style="width: 40%">
                  <input type="text" class="datetimepicker"style="width: 60%; height: 24px;" />
                  <script>
                      $('.datetimepicker').datetimepicker({
                          format: 'd/m/Y H:i',
                          step: 5
                      }).on("input change", function (e) {
                          if (role == "visitor" || (role == "editor" && owneruser != user))
                              return;
                          var dateStart = $(this).val();
                          var refDate = defaultDatabase.ref("games/" + gameId + "/date").set(dateStart);
                          // console.log(dateStart);
                      });
                  </script>
                </td>
              </tr>
              <tr>
                <td style="width: 10%">Bắt đầu</td>
                <td style="width: 40%; padding: 5px 0px" >
                  <img title="Bắt đầu" onclick="starttimermatch('round1')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete img_starttimermatchR1" src="img/play.png" />
                  <img title="Dừng" onclick="pausetimermatch('round1')" style="height: 40px; width: 40px;cursor:pointer; " class="img_delete img_stoptimermatchR1" src="img/pauseblue.png" />
                  <span class="timeMatch timeMatchRound1" style="margin-left: 20px; margin-right: 20px;"><time>00:00:00</time></span>
                    <img title="Kết thúc" onclick="stoptimermatch('round1')" style="height: 40px; width: 40px;cursor:pointer; " class="img_delete img_stoptimermatchR1" src="img/pausered.png" />
                </td>
                <td style="width: 10%">Vòng đấu</td>
                <td style="width: 40%; padding: 5px 0px" >
                    <select class="matchRound" style="width: 60%;"></select>
                  <%--<img title="Kết thúc" onclick="stoptimermatch('round1')" style="height: 40px; width: 40px;cursor:pointer; display: block;" class="img_delete img_stoptimermatchR1" src="img/pausered.png" />--%>
                </td>
              </tr>
            <tr>
                <td style="width: 10%">Người cập nhật</td>
                <td style="width: 40%"><select class="editor" style="width: 60%;"></select></td>
            </tr>
            </table>
            <div class="detailRound1"></div><!--.detailRound1-->
          </div><!--.tabcontent-->
          <div id="round2" class="tabcontent" style="display: none;">
              <table style="margin-left: 5%;margin-right: 5%; width: 90%">
                <tr>
                    <td style="width: 10%">Đội nhà</td>
                    <td style="width: 40%"><select class="homeclub club" style="width: 60%;"></select></td>
                    <td style="width: 10%">Đội khách</td>
                    <td style="width: 40%"><select class="awayclub club" style="width: 60%;"></select></td>
                </tr>
              <tr>
                <td style="width: 10%">Sân vận động</td>
                <td style="width: 40%"><select class="stadium" style="width: 60%;"></select></td>
                <td style="width: 10%">Thời gian</td>
                <td style="width: 40%">
                  <input type="text" class="datetimepicker"style="width: 60%; height: 24px;" />
                  <script>
                      $('.datetimepicker').datetimepicker({
                          format: 'd/m/Y H:i',
                          step: 5
                      }).on("input change", function (e) {
                          if (role == "visitor" || (role == "editor" && owneruser != user))
                              return;
                          var dateStart = $(this).val();
                          var refDate = defaultDatabase.ref("games/" + gameId + "/date").set(dateStart);
                          // console.log(dateStart);
                      });
                  </script>
                </td>
              </tr>
              <tr>
                <td style="width: 10%">Bắt đầu</td>
                <td style="width: 40%; padding: 5px 0px" >
                  <img title="Bắt đầu" onclick="starttimermatch('round2')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete img_starttimermatchR2" src="img/play.png" />
                  <img title="Dừng" onclick="pausetimermatch('round2')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete img_stoptimermatchR2" src="img/pauseblue.png" />
                  <span class="timeMatch timeMatchRound2" style="margin-left: 20px; margin-right: 20px;"><time>00:00:00</time></span>
                    <img title="Kết thúc" onclick="stoptimermatch('round2')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete img_stoptimermatchR1" src="img/pausered.png" />
                </td>
                <td style="width: 10%">Vòng đấu</td>
                <td style="width: 40%; padding: 5px 0px" >
                    <select class="matchRound" style="width: 60%;"></select>
                </td>
              </tr>
            <tr>
                <td style="width: 10%">Người cập nhật</td>
                <td style="width: 40%"><select class="editor" style="width: 60%;"></select></td>
            </tr>
            </table>
              <div class="detailRound2"></div><!--.detailRound2-->
          </div><!--.tabcontent-->
          <div id="round3" class="tabcontent" style="display: none;">
              <table style="margin-left: 5%;margin-right: 5%; width: 90%">
                <tr>
                    <td style="width: 10%">Đội nhà</td>
                    <td style="width: 40%"><select class="homeclub club" style="width: 60%;"></select></td>
                    <td style="width: 10%">Đội khách</td>
                    <td style="width: 40%"><select class="awayclub club" style="width: 60%;"></select></td>
                </tr>
              <tr>
                <td style="width: 10%">Sân vận động</td>
                <td style="width: 40%"><select class="stadium" style="width: 60%;"></select></td>
                <td style="width: 10%">Thời gian</td>
                <td style="width: 40%">
                  <input type="text" class="datetimepicker"style="width: 60%; height: 24px;" />
                  <script>
                      $('.datetimepicker').datetimepicker({
                          format: 'd/m/Y H:i',
                          step: 5
                      }).on("input change", function (e) {
                          if (role == "visitor" || (role == "editor" && owneruser != user))
                              return;
                          var dateStart = $(this).val();
                          var refDate = defaultDatabase.ref("games/" + gameId + "/date").set(dateStart);
                          // console.log(dateStart);
                      });
                  </script>
                </td>
              </tr>
              <tr>
                <td style="width: 10%">Thời gian trận</td>
                <td style="padding: 5px 0px; height: 50px; width: 40%" >
                  <span class="timeMatch timeMatchRoundAll" style=""><time>00:00:00</time></span>
                </td>
                <td style="width: 10%">Vòng đấu</td>
                <td style="width: 40%; padding: 5px 0px" >
                    <select class="matchRound" style="width: 60%;"></select>
                </td>
              </tr>
            <tr>
                <td style="width: 10%">Người cập nhật</td>
                <td style="width: 40%"><select class="editor" style="width: 60%;"></select></td>
            </tr>
            </table>
              <div class="detailRoundAll"></div><!--.detailRoundAll-->
          </div><!--.tabcontent-->
      </div><!--.wrapper_form-->
  </div><!--.wrapper_add_edit-->
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light" id="mainNav" style="background: #222222;">
      <div class="container">
        <a class="navbar-brand js-scroll-trigger" href="#page-top">VTVCAB</a>
        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <!-- Menu -->
          <i class="fa fa-bars"></i>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
            <!-- <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#download">Download</a>
            </li> -->
          </ul>
        </div>
      </div>
    </nav>
    <header class="masthead">
      <div class="container h-100" style="background: white">
        <!-- <input type="submit" value="Submit"> -->
        <span class="wrapper_btnAdd"><button type="button" class="btn btn-primary btnAdd" style="margin-top: 20px; cursor: pointer;">Thêm mới</button></span>
        <div class="logout" style="margin-top: 20px; float: right;">
            <span class="hiname" style="color: black;"></span>
            <a href="#" class="btnlogout">Thoát</a>
        </div>
        <div class="row" style="margin-top: 56px; clear: both; width: 100%">
            <div class="round" style="padding: 0% 2% 2% 2%; width: 100%;">
                <span style="color: black;">Vòng đấu: </span><span class="sl_round"></span>
            </div>
          <div class="col-lg-12 content">
            <div class="header-content mx-auto">
            </div>
          </div>
          <div class="col-lg-5 my-auto">
            <div class="device-container">
              <div class="device-mockup iphone6_plus portrait white" style="display: none">
                <div class="device">
                  <div class="screen">
                  </div>
                  <div class="button">
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>

    <footer>
      <div class="container">
        <p>&copy; 2017 Start Bootstrap. All Rights Reserved.</p>
        <ul class="list-inline">
          <li class="list-inline-item">
            <a href="#">Privacy</a>
          </li>
          <li class="list-inline-item">
            <a href="#">Terms</a>
          </li>
          <li class="list-inline-item">
            <a href="#">FAQ</a>
          </li>
        </ul>
      </div>
    </footer>

    <!-- Bootstrap core JavaScript -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/popper/popper.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Plugin JavaScript -->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for this template -->
    <script src="js/new-age.min.js"></script>
    <script>
        $(document).keyup(function (e) {
            if (e.keyCode == 27) { 
                $('.wrapper_add_edit').css("display", "none");
                clearTimeout(tR1);
                clearTimeout(tR2);
                clearTimeout(tawayR1);
                clearTimeout(tawayR2);
                clearTimeout(tmatchR1);
                clearTimeout(tmatchR2);
                tR1 = null;
                tR2 = null;
                tawayR1 = null;
                tawayR2 = null;
                tmatchR1 = null;
                tmatchR2 = null;
            }
        });
        if (role != "admin") {
            $('.wrapper_btnAdd').html("");
        }
        loadClub();
        loadRound();
        loadeditor();
        //$('.img_delete').click(function () {
        //    $(this).css("padding-left", "5px");
        //});
        $(document).ready(function () {
            if (role != "admin")
            {
                $('.editor').prop('disabled', 'disabled');
                $('.club').prop('disabled', 'disabled');
                $('.matchRound').prop('disabled', 'disabled');
                return;
            }
                

        });
        $('.close').click(function () {
            $('.wrapper_add_edit').css("display", "none");
            clearTimeout(tR1);
            clearTimeout(tR2);
            clearTimeout(tawayR1);
            clearTimeout(tawayR2);
            clearTimeout(tmatchR1);
            clearTimeout(tmatchR2);
            tR1 = null;
            tR2 = null;
            tawayR1 = null;
            tawayR2 = null;
            tmatchR1 = null;
            tmatchR2 = null;
        });
        $('.btnAdd').click(function () {
            if (role == "visitor")
                return;
            $('.wrapper_add_edit').css("display", "block");
            var refNew = ref.push().set({
                "awayname": "",
                "owneruser": "editor1",
                "round": leagueRound,
                "createdate": firebase.database.ServerValue.TIMESTAMP,
                "createuser": "",
                "deleted": 0,
                "homename": "",
                "name": "",
                "timematch": "00:00:00",
                "date": getToday(),
                "round1": {
                    "corners": {
                        "away": 0,
                        "home": 0
                    },
                    "fouls": {
                        "away": 0,
                        "home": 0
                    },
                    "goals": {
                        "away": 0,
                        "home": 0
                    },
                    "offsides": {
                        "away": 0,
                        "home": 0
                    },
                    "possession": {
                        "away": "00:00:00",
                        "home": "00:00:00"
                    },
                    "redcard": {
                        "away": 0,
                        "home": 0
                    },
                    "shots": {
                        "away": 0,
                        "home": 0
                    },
                    "shotsontarget": {
                        "away": 0,
                        "home": 0
                    },
                    "yellowcard": {
                        "away": 0,
                        "home": 0
                    },
                    "timematch": "00:00:00",
                    "finished": "0"
                },
                "round2": {
                    "corners": {
                        "away": 0,
                        "home": 0
                    },
                    "fouls": {
                        "away": 0,
                        "home": 0
                    },
                    "goals": {
                        "away": 0,
                        "home": 0
                    },
                    "offsides": {
                        "away": 0,
                        "home": 0
                    },
                    "possession": {
                        "away": "00:00:00",
                        "home": "00:00:00"
                    },
                    "redcard": {
                        "away": 0,
                        "home": 0
                    },
                    "shots": {
                        "away": 0,
                        "home": 0
                    },
                    "shotsontarget": {
                        "away": 0,
                        "home": 0
                    },
                    "yellowcard": {
                        "away": 0,
                        "home": 0
                    },
                    "timematch": "00:00:00",
                    "finished": "0"
                },
                "all": {
                    "corners": {
                        "away": 0,
                        "home": 0
                    },
                    "fouls": {
                        "away": 0,
                        "home": 0
                    },
                    "goals": {
                        "away": 0,
                        "home": 0
                    },
                    "offsides": {
                        "away": 0,
                        "home": 0
                    },
                    "possession": {
                        "away": "00:00:00",
                        "home": "00:00:00"
                    },
                    "redcard": {
                        "away": 0,
                        "home": 0
                    },
                    "shots": {
                        "away": 0,
                        "home": 0
                    },
                    "shotsontarget": {
                        "away": 0,
                        "home": 0
                    },
                    "yellowcard": {
                        "away": 0,
                        "home": 0
                    },
                    "timematch": "00:00:00",
                    "finished": "0"
                },
                "stadium": "",
                "updatedate": "",
                "updateuser": ""
            });
            ref.limitToLast(1).on("child_added", function (snapshot, prevChildKey) {
                var newPost = snapshot.val();
                gameId = snapshot.key;
                // Thông tin chung trận đấu
                var refGame = defaultDatabase.ref("games/" + gameId);
                refGame.on("value", function (snapshot) {
                    snapshot.forEach(function (e) {
                        if (e.key == "date") {
                            $('.datetimepicker').val(e.val());
                        }
                        if (e.key == "homename") {
                            $(".homeclub option").filter(function () {
                                return this.text == snapshot.val().homename;
                            }).attr('selected', true);
                        }
                        if (e.key == "awayname") {
                            $(".awayclub option").filter(function () {
                                return this.text == snapshot.val().awayname;
                            }).attr('selected', true);
                        }
                    });
                });
                getGameDetails();
                $('.tablinks label').css("background", "#eee");
                $('.defaultlabel').css("background", "cadetblue");
                //$('.tablinks label').css("background", "#eee");
                //$('.defaultlabel').css("background", "cadetblue");
            });
        });
        // Attach an asynchronous callback to read the data at our posts reference
        ref.orderByChild('createdate').limitToLast(1).on("value", function (snapshot) {
            snapshot.forEach(function (childSnapshot) {
                leagueRound = childSnapshot.val().round;
            });
            $(".dt_round option").filter(function () {
                return this.text == leagueRound;
            }).attr('selected', true);
            LeagueRound(leagueRound);
        });
        function LeagueRound( leagueR) {
            ref.orderByChild('round').equalTo(leagueR).on("value", function (snapshot) {
                //var newPost = snapshot.val();
                //alert(JSON.stringify(snapshot));
                var str = "";
                str += '<table style="width:100%;" class="tblGames">';
                str += '<tr>';
                str += '<th style="text-align: center;">STT</th>';
                str += '<th style="text-align: center;">Trạng thái</th>';
                str += '<th style="text-align: center;">Thời gian</th>';
                str += '<th style="text-align: center;">Người cập nhật</th>';
                str += '<th style="text-align: center;">Đội nhà</th>';
                str += '<th style="text-align: center;"></th>';
                str += '<th style="text-align: center;"></th>';
                str += '<th style="text-align: center;">Đội khách</th>';
                str += '<th style="text-align: center;">Hành động</th>';
                str += '</tr>';
                if (snapshot.val() != null)
                    var count = Object.keys(snapshot.val()).length + 1;
                var arrAll = "";
                snapshot.forEach(function (childSnapshot) {
                    arrEach = "";
                    if (childSnapshot.val().deleted == "0") {
                        var stt = "Chưa diễn ra";
                        if (childSnapshot.val().all.finished == "1")
                            stt = "Đã kết thúc";
                        else {
                            if (startedR1 == "1")
                                stt = "Đang diễn ra";
                        }
                        count--;
                        arrEach += '<tr>';
                        arrEach += '<td style="width: 4%; text-align: center;">' + count + '</td>';
                        arrEach += '<td style="width: 10%; text-align: center;">' + stt + '</td>';
                        arrEach += '<td style="width: 10%; text-align: center;">' + childSnapshot.val().date + '</td>';
                        arrEach += '<td style="width: 10%; text-align: center;">' + childSnapshot.val().owneruser + '</td>';
                        arrEach += '<td style="width: 15%; text-align: center;">' + childSnapshot.val().homename + '</td>';
                        arrEach += '<td style="width: 3%; text-align: center;">' + childSnapshot.val().all.goals.home + '</td>';
                        arrEach += '<td style="width: 3%; text-align: center;">' + childSnapshot.val().all.goals.away + '</td>';
                        arrEach += '<td style="width: 15%; text-align: center;">' + childSnapshot.val().awayname + '</td>';
                        //arrEach += '<td style="width: auto"><span style="cursor: pointer" onclick="editGameDetails(\'' + childSnapshot.key + '\')">' + childSnapshot.val().name + '</span></td>';
                        //arrEach += '<td style="width: 20%; text-align: center;">' + childSnapshot.val().stadium + '</td>';
                        arrEach += '<td style="text-align: center; width: 15%">';
                        arrEach += '<img title="Sửa" onclick="editGameDetails(\'' + childSnapshot.key + '\')" style="height: 25px; width: 25px;cursor:pointer; margin-right: 10px;" class="img_delete" src="img/settings.png"/>';
                        if (role != "visitor")
                            arrEach += '<img title="Xóa" onclick="deleteGames(\'' + childSnapshot.key + '\')" style="height: 25px; width: 25px; cursor:pointer;" class="img_delete" src="img/delete.png"/></td>';
                        arrEach += '</tr>';
                        arrAll = arrEach + arrAll;
                    }
                });
                str += arrAll;
                str += '</table>';
                $('.content').html(str);
            });
        }
        function loadRound() {
            var str = "";
            str += "<select style='width: 10%'; class='dt_round'>"
            for (i = 1; i < 27; i++) {
                str += "<option>"+i+"</option>"
            }
            str += "</select>"
            $('.sl_round').html(str);
            $('.matchRound').html(str);
        }
        function getToday() {
            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1; //January is 0!
            var yyyy = today.getFullYear();
            var mn = today.getMinutes();
            var h = today.getHours();
            if (dd < 10) {
                dd = '0' + dd
            }
            if (mm < 10) {
                mm = '0' + mm
            }
            if (h < 10) {
                h = '0' + h
            }
            if (mn < 10) {
                mn = '0' + mn
            }
            return today = dd + '/' + mm + '/' + yyyy + ' ' + h + ':' + mn;
        }
        function openCity(evt, cityName, round) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tabcontent");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tablinks");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(cityName).style.display = "block";
            evt.currentTarget.className += " active";

        }
        function deleteGames(gameId) {
            var refDel = defaultDatabase.ref("games/" + gameId + "/deleted").set("1");
        }
        function MatchInfo() {
            // Thông tin chung trận đấu
            var refGame = defaultDatabase.ref("games/" + gameId);
            refGame.on("value", function (snapshot) {
                snapshot.forEach(function (e) {
                    if (e.key == "date") {
                        $('.datetimepicker').val(e.val());
                    }
                    if (e.key == "homename") {
                        $(".homeclub option").filter(function () {
                            return this.text == snapshot.val().homename;
                        }).attr('selected', true);
                    }
                    if (e.key == "awayname") {
                        $(".awayclub option").filter(function () {
                            return this.text == snapshot.val().awayname;
                        }).attr('selected', true);
                    }
                    if (e.key == "stadium") {
                        $(".stadium option").filter(function () {
                            return this.text == snapshot.val().stadium;
                        }).attr('selected', true);
                    }
                    if (e.key == "round") {
                        $(".matchRound option").filter(function () {
                            return this.text == snapshot.val().round;
                        }).attr('selected', true);
                    }
                    if (e.key == "owneruser") {
                        owneruser = snapshot.val().owneruser;
                        $('.editor option:selected').removeAttr('selected');
                        $(".editor option").filter(function () {
                            return this.text == snapshot.val().owneruser;
                        }).attr('selected', true);
                    }
                });
            });
        }        
        function pauseTime(roundchange) {
            if (role == "visitor" || (role == "editor" && owneruser != user) || (role == "editor" && ((roundchange == "round1" && finishedR1 == "1") || (roundchange == "round2" && finishedR2 == "1")
                || (roundchange == "round2" && finishedR1 == "0") || (roundchange == "round1" && startedR1 == "0") || (roundchange == "round2" && startedR2 == "0")))) {
                return;
            }
            if (roundchange == "round1")
            {
                clearTimeout(tR1);
                clearTimeout(tawayR1);
                tR1 = null;
                tawayR1 = null;
                    $('.img_starthomeR1').css("display", "inline-block");
                    $('.img_pausehomeR1').css("display", "none");
                    $('.img_startawayR1').css("display", "inline-block");
                    $('.img_pauseawayR1').css("display", "none");
            }
            else {
                clearTimeout(tR2);
                clearTimeout(tawayR2);
                tR2 = null;
                tawayR2 = null;
                $('.img_starthomeR2').css("display", "inline-block");
                $('.img_pausehomeR2').css("display", "none");
                $('.img_startawayR2').css("display", "inline-block");
                $('.img_pauseawayR2').css("display", "none");
            }
        }
        function getGameDetails() {
            MatchInfo();
            // Thông tin hiệp 1
            var refRound1 = defaultDatabase.ref("games/" + gameId + "/round1");
            refRound1.on("value", function (snapshot) {
                var arrStr = "";
                var arrPossession = "";
                var corners = "";
                var fouls = "";
                var goals = "";
                var offsides = "";
                var redcard = "";
                var shots = "";
                var shotsontarget = "";
                var yellowcard = "";
                arrStr += '<table style="width: 96%;margin-left: 2%;margin-right: 2%;  margin-bottom: 30px;" class="tblGameDetail">';
                snapshot.forEach(function (e) {
                    if (e.key == "timematch") {
                        $(".timeMatchRound1").html(snapshot.val().timematch);
                        if (snapshot.val().timematch != "00:00:00")
                            startedR1 = "1";
                        var arrMatch = snapshot.val().timematch.split(":");
                        hoursmatchR1 = Number(arrMatch[0]); minutesmatchR1 = Number(arrMatch[1]); secondsmatchR1 = Number(arrMatch[2]);
                        return;
                    }
                    if (e.key == "finished") {
                        finishedR1 = e.val();
                        return;
                    }
                    if (e.key == "possession") {
                        var valHome = validatePossession('home', e.val().away, e.val().home);
                        var valAway = validatePossession('away', e.val().away, e.val().home);
                        var arrHome = e.val().home.split(":");
                        var arrAway = e.val().away.split(":");
                        hoursR1 = Number(arrHome[0]); minutesR1 = Number(arrHome[1]); secondsR1 = Number(arrHome[2]);
                        hoursawayR1 = Number(arrAway[0]); minutesawayR1 = Number(arrAway[1]); secondsawayR1 = Number(arrAway[2]);
                        var checkt = (tR1 != null) ? "none" : "inline-block";
                        var checktforpause = (tR1 != null) ? "inline-block" : "none";
                        var checkaway = (tawayR1 != null) ? "none" : "inline-block";
                        var checkawayforpause = (tawayR1 != null) ? "inline-block" : "none";

                        arrPossession += '<tr>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><span class="possessionaway">' + valHome + '</span></td>';
                        arrPossession += '<td style="width: 15%; text-align: center; padding: 5px 0px;"><span id="timehomeR1"><time>' + e.val().home + '</span></td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;">';
                        arrPossession += '<img title="Bắt đầu" onclick="starthomeAction(\'round1\')" style="height: 40px; width: 40px;cursor:pointer; display:' + checkt + ' " id="starthome" class="img_delete img_starthomeR1" src="img/play.png" />';
                        arrPossession += '<img title="Dừng" style="height: 40px; width: 40px;cursor:pointer; display:' + checktforpause + '" class="img_delete img_pausehomeR1" src="img/pausered.png"/>';
                        arrPossession += '</td>';
                        arrPossession += '<td style="width: auto; text-align: center; padding: 5px 0px;">Kiểm soát bóng</td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;">';
                        arrPossession += '<img title="Bắt đầu" onclick="startawayAction(\'round1\')" style="height: 40px; width: 40px;cursor:pointer;  display:' + checkaway + '" class="img_delete img_startawayR1" src="img/play.png"/>';
                        arrPossession += '<img title="Dừng" style="height: 40px; width: 40px;cursor:pointer; display:' + checkawayforpause + '" class="img_delete img_pauseawayR1" src="img/pausered.png"/>';
                        arrPossession += '</td>';
                        arrPossession += '<td style="width: 15%; text-align: center; padding: 5px 0px;"><span id="timeraway" ><time>' + e.val().away + '</time></span></td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><span class="possessionaway">' + valAway + '</span></td>';
                        arrPossession += '</tr>';
                        arrPossession += '<tr><td colspan="8" style="padding: 5px 0px; text-align: center;"><img title="" onclick="pauseTime(\'round1\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/pausered.png"/></td></tr>';
                    }
                    else {
                        if (e.key == "corners") {
                            corners += '<tr>';
                            corners += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            corners += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            corners += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            corners += '<td style="width: auto; text-align: center; padding: 5px 0px;">Phạt góc</td>';
                            corners += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            corners += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            corners += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            corners += '</tr>';
                        }
                        if (e.key == "fouls") {
                            fouls += '<tr>';
                            fouls += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            fouls += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            fouls += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            fouls += '<td style="width: auto; text-align: center; padding: 5px 0px;">Phạm lỗi</td>';
                            fouls += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            fouls += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            fouls += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            fouls += '</tr>';
                        }
                        if (e.key == "goals")
                        {
                            goals += '<tr>';
                            goals += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            goals += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            goals += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            goals += '<td style="width: auto; text-align: center; padding: 5px 0px;">Bàn thắng</td>';
                            goals += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            goals += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            goals += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            goals += '</tr>';
                        }
                        if (e.key == "offsides") {
                            offsides += '<tr>';
                            offsides += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            offsides += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            offsides += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            offsides += '<td style="width: auto; text-align: center; padding: 5px 0px;">Việt vị</td>';
                            offsides += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            offsides += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            offsides += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            offsides += '</tr>';
                        }
                        if (e.key == "redcard") {
                            redcard += '<tr>';
                            redcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            redcard += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            redcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            redcard += '<td style="width: auto; text-align: center; padding: 5px 0px;">Thẻ đỏ</td>';
                            redcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            redcard += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            redcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            redcard += '</tr>';
                        }
                        if (e.key == "shots") {
                            shots += '<tr>';
                            shots += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            shots += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            shots += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            shots += '<td style="width: auto; text-align: center; padding: 5px 0px;">Cú sút</td>';
                            shots += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            shots += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            shots += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            shots += '</tr>';
                        }
                        if (e.key == "shotsontarget") {
                            shotsontarget += '<tr>';
                            shotsontarget += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            shotsontarget += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            shotsontarget += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            shotsontarget += '<td style="width: auto; text-align: center; padding: 5px 0px;">Cú sút trúng đích</td>';
                            shotsontarget += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            shotsontarget += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            shotsontarget += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            shotsontarget += '</tr>';
                        }
                        if (e.key == "yellowcard") {
                            yellowcard += '<tr>';
                            yellowcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            yellowcard += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            yellowcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            yellowcard += '<td style="width: auto; text-align: center; padding: 5px 0px;">Thẻ vàng</td>';
                            yellowcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            yellowcard += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            yellowcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round1\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            yellowcard += '</tr>';
                        }
                        //arrStr = arrStr + goals + shots + shotsontarget + fouls + yellowcard + redcard + offsides + corners; 
                    }
                });
                arrStr = arrStr + goals + shots + shotsontarget + fouls + yellowcard + redcard + offsides + corners + arrPossession;
                arrStr += '  </table>';
                $('.detailRound1').html(arrStr);
            });
            // Thông tin hiệp 2
            var refRound2 = defaultDatabase.ref("games/" + gameId + "/round2");
            refRound2.on("value", function (snapshot) {
                var arrStr = "";
                var arrPossession = "";
                var corners = "";
                var fouls = "";
                var goals = "";
                var offsides = "";
                var redcard = "";
                var shots = "";
                var shotsontarget = "";
                var yellowcard = "";
                arrStr += '<table style="width: 96%;margin-left: 2%;margin-right: 2%;  margin-bottom: 30px;" class="tblGameDetail">';
                snapshot.forEach(function (e) {
                    if (e.key == "timematch") {
                        $(".timeMatchRound2").html(snapshot.val().timematch);
                        if (snapshot.val().timematch != "00:00:00")
                            startedR2 = "1";
                        var arrMatch = snapshot.val().timematch.split(":");
                        hoursmatchR2 = Number(arrMatch[0]); minutesmatchR2 = Number(arrMatch[1]); secondsmatchR2 = Number(arrMatch[2]);
                        return;
                    }
                    if (e.key == "finished") {
                        finishedR2 = e.val();
                        return;
                    }
                    if (e.key == "possession") {
                        var valHome = validatePossession('home', e.val().away, e.val().home);
                        var valAway = validatePossession('away', e.val().away, e.val().home);
                        var arrHome = e.val().home.split(":");
                        var arrAway = e.val().away.split(":");
                        hoursR2 = Number(arrHome[0]); minutesR2 = Number(arrHome[1]); secondsR2 = Number(arrHome[2]);
                        hoursawayR2 = Number(arrAway[0]); minutesawayR2 = Number(arrAway[1]); secondsawayR2 = Number(arrAway[2]);
                        var checkt = (tR2 != null) ? "none" : "inline-block";
                        var checktforpause = (tR2 != null) ? "inline-block" : "none";
                        var checkaway = (tawayR2 != null) ? "none" : "inline-block";
                        var checkawayforpause = (tawayR2 != null) ? "inline-block" : "none";

                        arrPossession += '<tr>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><span class="possessionaway">' + valHome + '</span></td>';
                        arrPossession += '<td style="width: 15%; text-align: center; padding: 5px 0px;"><span id="timehomeR2"><time>' + e.val().home + '</span></td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;">';
                        arrPossession += '<img title="Bắt đầu" onclick="starthomeAction(\'round2\')" style="height: 40px; width: 40px;cursor:pointer; display:' + checkt + ' " id="starthome" class="img_delete img_starthomeR2" src="img/play.png" />';
                        arrPossession += '<img title="Dừng" style="height: 40px; width: 40px;cursor:pointer; display:' + checktforpause + '" class="img_delete img_pausehomeR2" src="img/pausered.png"/>';
                        arrPossession += '</td>';
                        arrPossession += '<td style="width: auto; text-align: center; padding: 5px 0px;">Kiểm soát bóng</td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;">';
                        arrPossession += '<img title="Bắt đầu" onclick="startawayAction(\'round2\')" style="height: 40px; width: 40px;cursor:pointer;  display:' + checkaway + '" class="img_delete img_startawayR2" src="img/play.png"/>';
                        arrPossession += '<img title="Dừng" style="height: 40px; width: 40px;cursor:pointer; display:' + checkawayforpause + '" class="img_delete img_pauseawayR2" src="img/pausered.png"/>';
                        arrPossession += '</td>';
                        arrPossession += '<td style="width: 15%; text-align: center; padding: 5px 0px;"><span id="timeraway" ><time>' + e.val().away + '</time></span></td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><span class="possessionaway">' + valAway + '</span></td>';
                        arrPossession += '</tr>';
                        arrPossession += '<tr><td colspan="8" style="padding: 5px 0px; text-align: center;"><img title="" onclick="pauseTime(\'round2\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/pausered.png"/></td></tr>';
                    }
                    else {
                        if (e.key == "corners") {
                            corners += '<tr>';
                            corners += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            corners += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            corners += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            corners += '<td style="width: auto; text-align: center; padding: 5px 0px;">Phạt góc</td>';
                            corners += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            corners += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            corners += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            corners += '</tr>';
                        }
                        if (e.key == "fouls") {
                            fouls += '<tr>';
                            fouls += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            fouls += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            fouls += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            fouls += '<td style="width: auto; text-align: center; padding: 5px 0px;">Phạm lỗi</td>';
                            fouls += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            fouls += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            fouls += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            fouls += '</tr>';
                        }
                        if (e.key == "goals") {
                            goals += '<tr>';
                            goals += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            goals += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            goals += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            goals += '<td style="width: auto; text-align: center; padding: 5px 0px;">Bàn thắng</td>';
                            goals += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            goals += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            goals += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            goals += '</tr>';
                        }
                        if (e.key == "offsides") {
                            offsides += '<tr>';
                            offsides += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            offsides += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            offsides += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            offsides += '<td style="width: auto; text-align: center; padding: 5px 0px;">Việt vị</td>';
                            offsides += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            offsides += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            offsides += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            offsides += '</tr>';
                        }
                        if (e.key == "redcard") {
                            redcard += '<tr>';
                            redcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            redcard += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            redcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            redcard += '<td style="width: auto; text-align: center; padding: 5px 0px;">Thẻ đỏ</td>';
                            redcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            redcard += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            redcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            redcard += '</tr>';
                        }
                        if (e.key == "shots") {
                            shots += '<tr>';
                            shots += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            shots += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            shots += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            shots += '<td style="width: auto; text-align: center; padding: 5px 0px;">Cú sút</td>';
                            shots += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            shots += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            shots += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            shots += '</tr>';
                        }
                        if (e.key == "shotsontarget") {
                            shotsontarget += '<tr>';
                            shotsontarget += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            shotsontarget += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            shotsontarget += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            shotsontarget += '<td style="width: auto; text-align: center; padding: 5px 0px;">Cú sút trúng đích</td>';
                            shotsontarget += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            shotsontarget += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            shotsontarget += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            shotsontarget += '</tr>';
                        }
                        if (e.key == "yellowcard") {
                            yellowcard += '<tr>';
                            yellowcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            yellowcard += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            yellowcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            yellowcard += '<td style="width: auto; text-align: center; padding: 5px 0px;">Thẻ vàng</td>';
                            yellowcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                            yellowcard += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            yellowcard += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'round2\',\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                            yellowcard += '</tr>';
                        }
                    }

                });
                arrStr = arrStr + goals + shots + shotsontarget + fouls + yellowcard + redcard + offsides + corners + arrPossession;
                arrStr += '  </table>';
                $('.detailRound2').html(arrStr);
            });
            // Thông tin all
            var refRoundAll = defaultDatabase.ref("games/" + gameId + "/all");
            refRoundAll.on("value", function (snapshot) {
                var arrStr = "";
                var arrPossession = "";
                var corners = "";
                var fouls = "";
                var goals = "";
                var offsides = "";
                var redcard = "";
                var shots = "";
                var shotsontarget = "";
                var yellowcard = "";
                arrStr += '<table style="width: 50%;margin-left: 25%;  margin-bottom: 30px;" class="tblGameDetail">';
                arrStr += '<tr><td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;"></td><td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Đội nhà</td><td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Đội khách</td></tr>';
                snapshot.forEach(function (e) {
                    if (e.key == "timematch") {
                        $(".timeMatchRoundAll").html(snapshot.val().timematch);
                        return;
                    }
                    if (e.key == "finished") {
                        //finished = e.val();
                        return;
                    }
                    if (e.key == "possession") {
                        var valHome = validatePossession('home', e.val().away, e.val().home);
                        var valAway = validatePossession('away', e.val().away, e.val().home);
                        var arrHome = e.val().home.split(":");
                        var arrAway = e.val().away.split(":");
                        hours = Number(arrHome[0]); minutes = Number(arrHome[1]); seconds = Number(arrHome[2]);
                        hoursaway = Number(arrAway[0]); minutesaway = Number(arrAway[1]); secondsaway = Number(arrAway[2]);
                        arrPossession += '<tr>';
                        arrPossession += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Kiểm soát bóng</td>';
                        arrPossession += '<td style="width: 15%; height: 50px; padding: 5px 0px;"><span style="float: left; padding-left: 20%">' + e.val().home + '</span><span style="float: right; padding-right: 20%">' + valHome + '</span></td>';
                        arrPossession += '<td style="width: 15%; height: 50px; padding: 5px 0px;"><span style="float: left; padding-left: 20%">' + e.val().away + '</span><span style="float: right; padding-right: 20%">' + valAway + '</span></td>';
                        arrPossession += '</tr>';
                    }
                    else {
                        var validateKey = "";
                        if (e.key == "corners") {
                            corners += '<tr>';
                            corners += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Phạt góc</td>';
                            corners += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            corners += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            corners += '</tr>';
                        }
                        if (e.key == "fouls") {
                            fouls += '<tr>';
                            fouls += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Phạm lỗi</td>';
                            fouls += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            fouls += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            fouls += '</tr>';
                        }
                        if (e.key == "goals") {
                            goals += '<tr>';
                            goals += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Bàn thắng</td>';
                            goals += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            goals += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            goals += '</tr>';
                        }
                        if (e.key == "offsides") {
                            offsides += '<tr>';
                            offsides += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Việt vị</td>';
                            offsides += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            offsides += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            offsides += '</tr>';
                        }
                        if (e.key == "redcard") {
                            redcard += '<tr>';
                            redcard += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Thẻ đỏ</td>';
                            redcard += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            redcard += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            redcard += '</tr>';
                        }
                        if (e.key == "shots") {
                            shots += '<tr>';
                            shots += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Cú sút</td>';
                            shots += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            shots += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            shots += '</tr>';
                        }
                        if (e.key == "shotsontarget") {
                            shotsontarget += '<tr>';
                            shotsontarget += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Cú sút trúng đích</td>';
                            shotsontarget += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            shotsontarget += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            shotsontarget += '</tr>';
                        }
                        if (e.key == "yellowcard") {
                            yellowcard += '<tr>';
                            yellowcard += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">Thẻ vàng</td>';
                            yellowcard += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                            yellowcard += '<td style="width: 15%; height: 50px; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                            yellowcard += '</tr>';
                        }
                    }

                });
                arrStr = arrStr + goals + shots + shotsontarget + fouls + yellowcard + redcard + offsides + corners + arrPossession;
                arrStr += '  </table>';
                $('.detailRoundAll').html(arrStr);
            });
            openCity(event, 'round1')
        }
        // Sửa Game
        function editGameDetails(Id) {
            gameId = Id;
            $('.wrapper_add_edit').css("display", "block");
            getGameDetails();
            $('.tablinks label').css("background", "#eee");
            $('.defaultlabel').css("background", "cadetblue");
        }
        function updateGameDetails(roundchange, typeTeam, field, val) {
            if (role == "visitor" || (role == "editor" && owneruser != user) || (role == "editor" && ((roundchange == "round1" && finishedR1 == "1") || (roundchange == "round2" && finishedR2 == "1")
                || (roundchange == "round2" && finishedR1 == "0") || (roundchange == "round1" && startedR1 == "0") || (roundchange == "round2" && startedR2 == "0"))))
            {
                return;
            }
            if (Number(val) >= 0) {
                if (field == "shotsontarget") // Nếu là cú sút trúng đích thì tự động thêm mới vào sút
                {
                    // Cập nhật cho trừng trường
                    var refOldShot = defaultDatabase.ref("games/" + gameId + "/" + roundchange + "/shots/" + typeTeam);
                    var Oldshot = 0;
                    refOldShot.on("value", function (snapshot) {
                        Oldshot = Number(snapshot.val());
                    });
                    var refShotsontarget = defaultDatabase.ref("games/" + gameId + "/" + roundchange + "/shotsontarget/" + typeTeam);
                    var newShotsontarget = 0;
                    refShotsontarget.on("value", function (snapshot) {
                        if (Number(val) > Number(snapshot.val())) {
                            newShotsontarget = Oldshot + 1;
                        }
                        else {
                            newShotsontarget = Oldshot - 1;
                        }
                    });
                    var refUdShots = defaultDatabase.ref("games/" + gameId + "/" + roundchange + "/shots/" + typeTeam).set(newShotsontarget);

                    // Cập nhật gia trị cả trận đấu
                    var valAll = 0;
                    var refRound1 = defaultDatabase.ref("games/" + gameId + "/round1/shots/" + typeTeam);
                    refRound1.on("value", function (snap) {
                        valAll += Number(snap.val());
                    });
                    var refRound2 = defaultDatabase.ref("games/" + gameId + "/round2/shots/" + typeTeam);
                    refRound2.on("value", function (snap) {
                        valAll += Number(snap.val());
                    });
                    var refAll = defaultDatabase.ref("games/" + gameId + "/all/shots/" + typeTeam).set(valAll);
                }

                // Cập nhật gia trị cả trận đấu
                var refRound = defaultDatabase.ref("games/" + gameId + "/" + roundchange + "/" + field + "/" + typeTeam).set(val);
                var valAll = 0;
                var refRound1 = defaultDatabase.ref("games/" + gameId + "/round1/" + field + "/" + typeTeam);
                refRound1.on("value", function (snap) {
                    valAll += Number(snap.val());
                });
                var refRound2 = defaultDatabase.ref("games/" + gameId + "/round2/" + field + "/" + typeTeam);
                refRound2.on("value", function (snap) {
                    valAll += Number(snap.val());
                });
                var refAll = defaultDatabase.ref("games/" + gameId + "/all/" + field + "/" + typeTeam).set(valAll);

                //pushDetail(field, typeTeam);
            }

        }
        function updateGamePossession(roundchange, typeTeam, val) {
            if (role == "visitor" || (role == "editor" && owneruser != user) || (role == "editor" && ((roundchange == "round1" && finishedR1 == "1") || (roundchange == "round2" && finishedR2 == "1")
                || (roundchange == "round2" && finishedR1 == "0") || (roundchange == "round1" && startedR1 == "0") || (roundchange == "round2" && startedR2 == "0")))) {
                return;
            }

            var refRound = defaultDatabase.ref("games/" + gameId + "/" + roundchange + "/possession/" + typeTeam).set(val);
            // Cập nhật thời gian cho cả 2 hiệp
            var secondsAll = 0, minutesAll = 0, hoursAll = 0;
            var secondRound1 = 0, secondRound2 = 0;
            var refRound1 = defaultDatabase.ref("games/" + gameId + "/round1/possession/" + typeTeam);
            refRound1.on("value", function (snapshot) {
                var arrRound1 = snapshot.val().split(":");
                secondRound1 = (+arrRound1[0]) * 60 * 60 + (+arrRound1[1]) * 60 + (+arrRound1[2]);
            });
            var refRound2 = defaultDatabase.ref("games/" + gameId + "/round2/possession/" + typeTeam);
            refRound2.on("value", function (snapshot) {
                var arrRound2 = snapshot.val().split(":");
                secondRound2 = (+arrRound2[0]) * 60 * 60 + (+arrRound2[1]) * 60 + (+arrRound2[2]);
            });
            secondsAll = secondRound1 + secondRound2;
            hoursAll = Math.floor(secondsAll / 3600);
            secondsAll -= hoursAll * 3600;
            minutesAll = Math.floor(secondsAll / 60);
            secondsAll -= minutesAll * 60;
            var display = (hoursAll ? (hoursAll > 9 ? hoursAll : "0" + hoursAll) : "00") + ":" + (minutesAll ? (minutesAll > 9 ? minutesAll : "0" + minutesAll) : "00") + ":" + (secondsAll > 9 ? secondsAll : "0" + secondsAll);
            var refRound = defaultDatabase.ref("games/" + gameId + "/all/possession/" + typeTeam).set(display);
        }
        function updateTimeMatch(roundTime, val) {
            var refRound = defaultDatabase.ref("games/" + gameId + "/" + roundTime + "/timematch").set(val);
            //var refRound = defaultDatabase.ref("games/" + gameId + "/round1/timematch").set(val);
            // Cập nhật thời gian cho cả 2 hiệp
            var secondsAll = 0, minutesAll = 0, hoursAll = 0;
            var secondRound1 = 0, secondRound2 = 0;
            var refRound1 = defaultDatabase.ref("games/" + gameId + "/round1/timematch");
            refRound1.on("value", function (snapshot) {
                var arrRound1 = snapshot.val().split(":");
                secondRound1 = (+arrRound1[0]) * 60 * 60 + (+arrRound1[1]) * 60 + (+arrRound1[2]);
                if (Number(secondRound1) > 2700)
                    secondRound1 = 2700;
            });
            var refRound2 = defaultDatabase.ref("games/" + gameId + "/round2/timematch");
            refRound2.on("value", function (snapshot) {
                var arrRound2 = snapshot.val().split(":");
                secondRound2 = (+arrRound2[0]) * 60 * 60 + (+arrRound2[1]) * 60 + (+arrRound2[2]);
            });
            secondsAll = secondRound1 + secondRound2;
            hoursAll = Math.floor(secondsAll / 3600);
            secondsAll -= hoursAll * 3600;
            minutesAll = Math.floor(secondsAll / 60);
            secondsAll -= minutesAll * 60;
            var display = (hoursAll ? (hoursAll > 9 ? hoursAll : "0" + hoursAll) : "00") + ":" + (minutesAll ? (minutesAll > 9 ? minutesAll : "0" + minutesAll) : "00") + ":" + (secondsAll > 9 ? secondsAll : "0" + secondsAll);
            var refRound = defaultDatabase.ref("games/" + gameId + "/all/timematch").set(display);
        }
        // Đếm giờ
        function validatePossession(typeTeam, possAway, possHome) {
            var arrpossAway = possAway.split(":");
            var secondsaway = (+arrpossAway[0]) * 60 * 60 + (+arrpossAway[1]) * 60 + (+arrpossAway[2]);
            var arrpossHome = possHome.split(":");
            var secondshome = (+arrpossHome[0]) * 60 * 60 + (+arrpossHome[1]) * 60 + (+arrpossHome[2]);

            if ((secondsaway + secondshome) == 0) {
                return "00,00%";
            }
            if (typeTeam == "home" && possAway == 0) {
                return "100,00%";
            }
            if (typeTeam == "away" && possHome == 0) {
                return "100,00%";
            }
            var poss = (Number(secondshome) / (Number(secondsaway) + Number(secondshome))) * 100;
            poss = Math.round(poss * 100) / 100;

            if (typeTeam == "home") {
                return poss + "%";
            }
            else {
                return (Math.round((100 - poss) * 100) / 100) + "%";
            }
        }
        /*****Thời gian trận đấu***/
        function addmatchR1() {
            secondsmatchR1++;
            if (secondsmatchR1 >= 60) {
                secondsmatchR1 = 0;
                minutesmatchR1++;
                if (minutesmatchR1 >= 60) {
                    minutesmatchR1 = 0;
                    hoursmatchR1++;
                }
            }
            var display = (hoursmatchR1 ? (hoursmatchR1 > 9 ? hoursmatchR1 : "0" + hoursmatchR1) : "00") + ":" + (minutesmatchR1 ? (minutesmatchR1 > 9 ? minutesmatchR1 : "0" + minutesmatchR1) : "00") + ":" + (secondsmatchR1 > 9 ? secondsmatchR1 : "0" + secondsmatchR1);
            updateTimeMatch("round1",display);
            timermatchR1();
        }
        function timermatchR1() {
            tmatchR1 = setTimeout(addmatchR1, 1000);
        }
        function addmatchR2() {
            secondsmatchR2++;
            if (secondsmatchR2 >= 60) {
                secondsmatchR2 = 0;
                minutesmatchR2++;
                if (minutesmatchR2 >= 60) {
                    minutesmatchR2 = 0;
                    hoursmatchR2++;
                }
            }
            var display = (hoursmatchR2 ? (hoursmatchR2 > 9 ? hoursmatchR2 : "0" + hoursmatchR2) : "00") + ":" + (minutesmatchR2 ? (minutesmatchR2 > 9 ? minutesmatchR2 : "0" + minutesmatchR2) : "00") + ":" + (secondsmatchR2 > 9 ? secondsmatchR2 : "0" + secondsmatchR2);
            updateTimeMatch("round2", display);
            timermatchR2();
        }
        function timermatchR2() {
            tmatchR2 = setTimeout(addmatchR2, 1000);
        }
        function starttimermatch(roundTime) {
            if (role == "visitor" || (role == "editor" && owneruser != user) || (role == "editor" && ((roundTime == "round1" && finishedR1 == "1") || (roundTime == "round2" && finishedR2 == "1")
                || (roundTime == "round2" && finishedR1 == "0")))) {
                return;
            }
            
            if (roundTime == "round1")
            {
                clearTimeout(tmatchR1);
                tmatchR1 = null;
                timermatchR1();
            }
            else
            {
                clearTimeout(tmatchR2);
                tmatchR2 = null;
                timermatchR2();
            }
            //$('.img_starttimermatch').css("display", "none");
            //$('.img_stoptimermatch').css("display", "inline-block");
        }
        function stoptimermatch(roundchange) {
            if (role == "visitor" || (role == "editor" && owneruser != user) || (role == "editor" && ((roundchange == "round1" && finishedR1 == "1") || (roundchange == "round2" && finishedR2 == "1")
                || (roundchange == "round2" && finishedR1 == "0") || (roundchange == "round1" && startedR1 == "0") || (roundchange == "round2" && startedR2 == "0")))) {
                return;
            }
            if (roundchange == "round1") {
                if (startedR1 == "0") return;
                clearTimeout(tmatchR1);
                tmatchR1 = null;
            }
            else {
                if (startedR2 == "0") return;
                clearTimeout(tmatchR2);
                tmatchR2 = null;
                var refFinished = defaultDatabase.ref("games/" + gameId + "/all/finished").set("1");
            }
            var refFinished = defaultDatabase.ref("games/" + gameId + "/" + roundchange + "/finished").set("1");
            $('.img_starthomeR2').css("display", "inline-block");
            $('.img_pausehomeR2').css("display", "none");
            $('.img_startawayR2').css("display", "inline-block");
            $('.img_pauseawayR2').css("display", "none");
        }
        function pausetimermatch(roundchange) {
            if (role == "visitor" || (role == "editor" && owneruser != user) || (role == "editor" && ((roundchange == "round1" && finishedR1 == "1") || (roundchange == "round2" && finishedR2 == "1")
                || (roundchange == "round2" && finishedR1 == "0") || (roundchange == "round1" && startedR1 == "0") || (roundchange == "round2" && startedR2 == "0")))) {
                return;
            }
            if (roundchange == "round1")
            {
                clearTimeout(tmatchR1);
                tmatchR1 = null;
            }
            else
            {
                clearTimeout(tmatchR2);
                tmatchR2 = null;
                //var refFinished = defaultDatabase.ref("games/" + gameId + "/all/finished").set("1");
            }
            //var refFinished = defaultDatabase.ref("games/" + gameId + "/" + roundchange + "/finished").set("1");
        }
        /*****End Thời gian trận đấu***/
        function pushDetail(field, typeTeam) {
            var ref = defaultDatabase.ref("games/" + gameId + "/" + round + "/" + field);
            var refNew = ref.push().set({
                "date": getToday(),
                "typeteam": typeTeam
            });
        }
        function loadClub() {
            var refClub = defaultDatabase.ref("clubs");
            refClub.on("value", function (snapshot) {
                var str = "";
                var strStadium = "";
                snapshot.forEach(function (e) {
                    str += '<option value="">' + e.val().name + '</option>';
                    strStadium += '<option value="">' + e.val().stadium + '</option>';
                });
                $('.club').html(str);
                $('.stadium').html(strStadium);
            })
        }
        function loadeditor() {
            var refeditor = defaultDatabase.ref("users");
            refeditor.orderByChild("role").equalTo("editor").on("value", function (snapshot) {
                var str = "";
                snapshot.forEach(function (e) {
                    str += '<option value="">' + e.val().username + '</option>';
                });
                $('.editor').html(str);
            })
        }
        $('.homeclub').change(function () {
            if (role != "admin")
                return;
            var valHome = $('option:selected',this).text();
            var valAway = "";
            refOldAway = defaultDatabase.ref("games/" + gameId + "/awayname");
            refOldAway.on("value", function (snapshot) {
                valAway = snapshot.val();
            })
            var refHome = defaultDatabase.ref("games/" + gameId + "/homename").set(valHome);
            var refnameMatch = defaultDatabase.ref("games/" + gameId + "/name").set(valHome + "<span style='color: blue'> vs </span>" + valAway);
        });
        $('.awayclub').change(function () {
            if (role != "admin")
                return;
            //var valHome = $('.homeclub option:selected').text();
            var valHome = "";
            refOldHome = defaultDatabase.ref("games/" + gameId + "/homename");
            refOldHome.on("value", function (snapshot) {
                valHome = snapshot.val();
            })
            var valAway = $('option:selected',this).text();
            var refAway = defaultDatabase.ref("games/" + gameId + "/awayname").set(valAway);
            var refnameMatch = defaultDatabase.ref("games/" + gameId + "/name").set(valHome + "<span style='color: blue'> vs </span>" + valAway);
        });
        $('.stadium').change(function () {
            if (role == "visitor" || (role == "editor" && owneruser != user))
                return;
            var valStadium = $('option:selected',this).text();
            var refStadium = defaultDatabase.ref("games/" + gameId + "/stadium").set(valStadium);
        });
        $('.matchRound').change(function () {
            if (role != "visitor")
                return;
            var valmatchRound = $('option:selected', this).text();
            var refmatchRound = defaultDatabase.ref("games/" + gameId + "/round").set(valmatchRound);
        });
        $(".dt_round").change(function () {
            var dtRound = $('option:selected', this).text();
            LeagueRound(dtRound);
        });
        $('.editor').change(function () {
            if (role != "admin")
                return;
            var valmatchRound = $('option:selected', this).text();
            var refmatchRound = defaultDatabase.ref("games/" + gameId + "/owneruser").set(valmatchRound);
        });
        /***Tắt bật kiểm soát bóng***/
        function addR1() {
            secondsR1++;
            if (secondsR1 >= 60) {
                secondsR1 = 0;
                minutesR1++;
                if (minutesR1 >= 60) {
                    minutesR1 = 0;
                    hoursR1++;
                }
            }
            var display = (hoursR1 ? (hoursR1 > 9 ? hoursR1 : "0" + hoursR1) : "00") + ":" + (minutesR1 ? (minutesR1 > 9 ? minutesR1 : "0" + minutesR1) : "00") + ":" + (secondsR1 > 9 ? secondsR1 : "0" + secondsR1);
            updateGamePossession('round1', 'home', display);
            $('#timehomeR1').html(display);
            timerR1();
        }
        function timerR1() {
            clearTimeout(tawayR1);
            tR1 = setTimeout(addR1, 1000);
        }
        function addR2() {
            secondsR2++;
            if (secondsR2 >= 60) {
                secondsR2 = 0;
                minutesR2++;
                if (minutesR2 >= 60) {
                    minutesR2 = 0;
                    hoursR2++;
                }
            }
            var display = (hoursR2 ? (hoursR2 > 9 ? hoursR2 : "0" + hoursR2) : "00") + ":" + (minutesR2 ? (minutesR2 > 9 ? minutesR2 : "0" + minutesR2) : "00") + ":" + (secondsR2 > 9 ? secondsR2 : "0" + secondsR2);
            updateGamePossession('round2', 'home', display);
            $('#timehomeR2').html(display);
            timerR2();
        }
        function timerR2() {
            clearTimeout(tawayR2);
            tR2 = setTimeout(addR2, 1000);
        }
        function addawayR1() {
            secondsawayR1++;
            if (secondsawayR1 >= 60) {
                secondsawayR1 = 0;
                minutesawayR1++;
                if (minutesawayR1 >= 60) {
                    minutesawayR1 = 0;
                    hoursawayR1++;
                }
            }
            var display = (hoursawayR1 ? (hoursawayR1 > 9 ? hoursawayR1 : "0" + hoursawayR1) : "00") + ":" + (minutesawayR1 ? (minutesawayR1 > 9 ? minutesawayR1 : "0" + minutesawayR1) : "00") + ":" + (secondsawayR1 > 9 ? secondsawayR1 : "0" + secondsawayR1);
            updateGamePossession('round1', 'away', display);
            timerawayR1();
        }
        function timerawayR1() {
            clearTimeout(tR1);
            tawayR1 = setTimeout(addawayR1, 1000);
        }
        function addawayR2() {
            secondsawayR2++;
            if (secondsawayR2 >= 60) {
                secondsawayR2 = 0;
                minutesawayR2++;
                if (minutesawayR2 >= 60) {
                    minutesawayR2 = 0;
                    hoursawayR2++;
                }
            }
            var display = (hoursawayR2 ? (hoursawayR2 > 9 ? hoursawayR2 : "0" + hoursawayR2) : "00") + ":" + (minutesawayR2 ? (minutesawayR2 > 9 ? minutesawayR2 : "0" + minutesawayR2) : "00") + ":" + (secondsawayR2 > 9 ? secondsawayR2 : "0" + secondsawayR2);
            updateGamePossession('round2', 'away', display);
            timerawayR2();
        }
        function timerawayR2() {
            clearTimeout(tR2);
            tawayR2 = setTimeout(addawayR2, 1000);
        }
        function starthomeAction(roundchange) {
            if (role == "visitor" || (role == "editor" && owneruser != user) || (role == "editor" && ((roundchange == "round1" && finishedR1 == "1") || (roundchange == "round2" && finishedR2 == "1")
                || (roundchange == "round2" && finishedR1 == "0") || (roundchange == "round1" && startedR1 == "0") || (roundchange == "round2" && startedR2 == "0")))) {
                return;
            }
            if (roundchange == "round1")
            {
                clearTimeout(tR1);
                timerR1();
                tawayR1 = null;
            }
            else {
                clearTimeout(tR2);
                timerR2();
                tawayR2 = null;
            }
        }
        function startawayAction(roundchange) {
            if (role == "visitor" || (role == "editor" && owneruser != user) || (role == "editor" && ((roundchange == "round1" && finishedR1 == "1") || (roundchange == "round2" && finishedR2 == "1")
                || (roundchange == "round2" && finishedR1 == "0") || (roundchange == "round1" && startedR1 == "0") || (roundchange == "round2" && startedR2 == "0")))) {
                return;
            }
            if (roundchange == "round1") {
                clearTimeout(tawayR1);
                timerawayR1();
                tR1 = null;
            }
            else {
                clearTimeout(tawayR2);
                timerawayR2();
                tR2 = null;
            }
            
        }
        /***End tắt bật kiểm soát bóng***/
        $('.hiname').html("Xin chào " + user + ", ");
        $('.btnlogout').click(function () {
            var params = {};
            $.ajax
            ({
                type: "POST",
                url: "Handlers/Logout.ashx",
                data: params,
                async: false,
                dataType: 'json',
                success: function (data) {
                    if (data != null) {
                        window.location.href = "login.aspx";
                    }
                    else {
                        return null;
                    }
                },
                error: function (result) {
                    return null;
                }
            });

        })
        /***Chinh sua tab***/
        $('.tablinks label').click(function () {
            $('.tablinks label').css("background", "#eee");
            $(this).css("background", "cadetblue");
        });
        /***End Chinh sua tab***/

     </script>
    </form>
</body>
</html>
