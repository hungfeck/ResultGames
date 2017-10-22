<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="ResultGame.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>VTVCAB</title>
    <!-- Bootstrap core CSS -->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Custom fonts for this template -->
    <link rel="stylesheet" href="vendor/font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" href="vendor/simple-line-icons/css/simple-line-icons.css" />
    <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Muli" rel="stylesheet">

    <!-- Plugin CSS -->
    <link rel="stylesheet" href="device-mockups/device-mockups.css">

    <!-- Custom styles for this template -->
    <link href="css/new-age.css" rel="stylesheet"/>
    <link href="date/jquery.datetimepicker.css" rel="stylesheet">
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
       var defaultApp = firebase.initializeApp(config);
       var defaultDatabase = defaultApp.database();
       var ref = defaultDatabase.ref("games");
       var h1 = document.getElementById('timehome'),
        //  start = document.getElementById('starthome'),
         seconds = 0, minutes = 0, hours = 0, secondsaway = 0, minutesaway = 0, hoursaway = 0, secondsmatch = 0, minutesmatch = 0, hoursmatch = 0,
         t, taway, tmatch;
       var finished = "0";
       var role = "viewer", user = "";
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
      <div class="wrapper_form" id="wrapper_form" style="margin-top: 70px; ">
          <div class="close" style="padding-right: 10px; cursor: pointer;">
              <h3 style="float: right;">&times;</h3>
          </div>
          <div class="tab">
              <div class="tablinks tablinks_details " onclick="getGameDetails('round1')" id="defaultOpen"><label for="tab-2" class="defaultlabel">Hiệp 1</label></div>
              <div class="tablinks tablinks_manageUserSale" onclick="getGameDetails('round2')"><label for="tab-2">Hiệp 2</label></div>
              <div class="tablinks tablinks_manageUserGroup" onclick="getGameDetails('all')"><label for="tab-2">Tất cả</label></div>
          </div>
          <div id="London" class="tabcontent">
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
                          if (role == "viewer")
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
                <td colspan="8"; style="padding: 5px 0px" >
                  <img title="" onclick="starttimermatch()" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete img_starttimermatch" src="img/play.png">
                  <img title="" onclick="stoptimermatch()" style="height: 40px; width: 40px;cursor:pointer; display: none;" class="img_delete img_stoptimermatch" src="img/pausered.png">
                  <span class="timeMatch" style="margin-left: 20px;"><time>00:00:00</time></span>
                </td>
              </tr>
            </table>

              <div class="wrapper_infor" style="padding-top: 15px;">
              </div><!--.wrapper_infor-->
          </div><!--.tabcontent-->
      </div><!--.wrapper_form-->
  </div><!--.wrapper_add_edit-->

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top" id="mainNav" style="background: #0072C6;">
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
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#features">Features</a>
            </li>
            <li class="nav-item">
              <a class="nav-link js-scroll-trigger" href="#contact">Contact</a>
            </li> -->
          </ul>
        </div>
      </div>
    </nav>

    <header class="masthead">
      <div class="container h-100" style="background: white">
        <!-- <input type="submit" value="Submit"> -->
        <button type="button" class="btn btn-primary btnAdd" style="margin-top: 60px; cursor: pointer;">Thêm mới</button>
        <div class="logout" style="margin-top: 60px; float: right;">
            <span class="hiname" style="color: black;"></span>
            <a href="#" class="btnlogout">Thoát</a>
        </div>
        
        <div class="row" style="margin-top: 56px;">
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
       
        loadClub();
        $('.close').click(function () {
            $('.wrapper_add_edit').css("display", "none");
            clearTimeout(t);
            clearTimeout(taway);
            clearTimeout(tmatch);
        });
        $('.btnAdd').click(function () {
            if (role == "viewer")
                return;
            $('.wrapper_add_edit').css("display", "block");
            var refNew = ref.push().set({
                "awayname": "",
                "createdate": getToday(),
                "createuser": "",
                "deleted": 0,
                "homename": "",
                "name": "",
                "timematch": "00:00:00",
                "date": "00:00:00",
                "round1": {
                    "7corners": {
                        "away": 0,
                        "home": 0
                    },
                    "3fouls": {
                        "away": 0,
                        "home": 0
                    },
                    "0goals": {
                        "away": 0,
                        "home": 0
                    },
                    "6offsides": {
                        "away": 0,
                        "home": 0
                    },
                    "8possession": {
                        "away": "00:00:00",
                        "home": "00:00:00"
                    },
                    "5redcard": {
                        "away": 0,
                        "home": 0
                    },
                    "1shots": {
                        "away": 0,
                        "home": 0
                    },
                    "2shotsontarget": {
                        "away": 0,
                        "home": 0
                    },
                    "4yellowcard": {
                        "away": 0,
                        "home": 0
                    },
                    "timematch": "00:00:00",
                    "finished": "0"
                },
                "round2": {
                    "7corners": {
                        "away": 0,
                        "home": 0
                    },
                    "3fouls": {
                        "away": 0,
                        "home": 0
                    },
                    "0goals": {
                        "away": 0,
                        "home": 0
                    },
                    "6offsides": {
                        "away": 0,
                        "home": 0
                    },
                    "8possession": {
                        "away": "00:00:00",
                        "home": "00:00:00"
                    },
                    "5redcard": {
                        "away": 0,
                        "home": 0
                    },
                    "1shots": {
                        "away": 0,
                        "home": 0
                    },
                    "2shotsontarget": {
                        "away": 0,
                        "home": 0
                    },
                    "4yellowcard": {
                        "away": 0,
                        "home": 0
                    },
                    "timematch": "00:00:00",
                    "finished": "0"
                },
                "all": {
                    "7corners": {
                        "away": 0,
                        "home": 0
                    },
                    "3fouls": {
                        "away": 0,
                        "home": 0
                    },
                    "0goals": {
                        "away": 0,
                        "home": 0
                    },
                    "6offsides": {
                        "away": 0,
                        "home": 0
                    },
                    "8possession": {
                        "away": "00:00:00",
                        "home": "00:00:00"
                    },
                    "5redcard": {
                        "away": 0,
                        "home": 0
                    },
                    "1shots": {
                        "away": 0,
                        "home": 0
                    },
                    "2shotsontarget": {
                        "away": 0,
                        "home": 0
                    },
                    "4yellowcard": {
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
                getGameDetails('round1');
                $('.tablinks label').css("background", "#eee");
                $('.defaultlabel').css("background", "cadetblue");
                // console.log("Previous Post ID: " + prevChildKey);
            });
        });

        // Attach an asynchronous callback to read the data at our posts reference
        ref.on("value", function (snapshot) {
            var newPost = snapshot.val();
            var str = "";
            str += '<table style="width:100%;" class="tblGames">';
            str += '<tr>';
            str += '<th style="text-align: center;">Stt</th>';
            str += '<th style="text-align: center;">Trận đấu</th>';
            str += '<th style="text-align: center;">Thời gian</th>';
            str += '<th style="text-align: center;">Sân vận động</th>';
            str += '<th style="text-align: center;">Hành động</th>';
            str += '</tr>';
            var count = 0;
            snapshot.forEach(function (childSnapshot) {
                if (childSnapshot.val().deleted == "0") {
                    count++;
                    str += '<tr>';
                    str += '<td style="width: 4%; text-align: center;">' + count + '</td>';
                    str += '<td style="width: auto">' + childSnapshot.val().name + '</td>';
                    str += '<td style="width: 20%">' + childSnapshot.val().date + '</td>';
                    str += '<td style="width: 30%">' + childSnapshot.val().stadium + '</td>';
                    str += '<td style="text-align: center; width: 15%">';
                    str += '<img title="Sửa" onclick="editGameDetails(\'' + childSnapshot.key + '\')" style="height: 25px; width: 25px;cursor:pointer; margin-right: 10px;" class="img_delete" src="img/settings.png"/>';
                    if(role != "viewer")
                        str +=   '<img title="Xóa" onclick="deleteGames(\'' + childSnapshot.key + '\')" style="height: 25px; width: 25px; cursor:pointer;" class="img_delete" src="img/delete.png"/></td>';
                    str += '</tr>';
                }

            });
            str += '</table>';
            $('.content').html(str);
        });

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
        function getGameDetails(roundchange) {

            round = roundchange;
            clearTimeout(t);
            clearTimeout(taway);
            clearTimeout(tmatch);
            t = null, taway = null;
            // Đổi màu cho tablinks
            $('.tablinks label').click(function () {
                $('.tablinks label').css("background", "#eee");
                $(this).css("background", "cadetblue");
            });


            var refStadium = defaultDatabase.ref("games/" + gameId + "/stadium");
            $('.stadium option:selected').removeAttr('selected');
            $('.homeclub option:selected').removeAttr('selected');
            $('.awayclub option:selected').removeAttr('selected');
            refStadium.on("value", function (snapshot) {
                // alert($('.stadium :selected').text()) ;
                $(".stadium option").filter(function () {
                    return this.text == snapshot.val();
                }).attr('selected', true);
            });

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
            // Thời gian trận
            var refTimeMatch = defaultDatabase.ref("games/" + gameId + "/" + round + "/timematch");
            refTimeMatch.on("value", function (snapshot) {
                $(".timeMatch").html(snapshot.val());
                if (snapshot.val() != "00:00:00") {
                    $('.img_starttimermatch').css("display", "none");
                    $('.img_stoptimermatch').css("display", "inline-block");
                }
                else {
                    $('.img_starttimermatch').css("display", "inline-block");
                    $('.img_stoptimermatch').css("display", "none");
                }
                // alert("timematch "+snapshot.val());
                var arrMatch = snapshot.val().split(":");
                hoursmatch = Number(arrMatch[0]); minutesmatch = Number(arrMatch[1]); secondsmatch = Number(arrMatch[2]);
            });
            // Thông tin trận
            var refRound = defaultDatabase.ref("games/" + gameId + "/" + round);
            refRound.on("value", function (snapshot) {
                var arrStr = "";
                var arrPossession = "";
                arrStr += '<table style="width: 96%;margin-left: 2%;margin-right: 2%;  margin-bottom: 30px;" class="tblGameDetail">';
                snapshot.forEach(function (e) {
                    if (e.key == "timematch") {
                        return;
                    }
                    if (e.key == "finished") {
                        finished = e.val();
                        return;
                    }
                    if (e.key == "8possession") {
                        var valHome = validatePossession('home', e.val().away, e.val().home);
                        var valAway = validatePossession('away', e.val().away, e.val().home);
                        var arrHome = e.val().home.split(":");
                        var arrAway = e.val().away.split(":");
                        hours = Number(arrHome[0]); minutes = Number(arrHome[1]); seconds = Number(arrHome[2]);
                        hoursaway = Number(arrAway[0]); minutesaway = Number(arrAway[1]); secondsaway = Number(arrAway[2]);
                        var checkt = (t != null) ? "none" : "inline-block";
                        var checktforpause = (t != null) ? "inline-block" : "none";
                        var checkaway = (taway != null) ? "none" : "inline-block";
                        var checkawayforpause = (taway != null) ? "inline-block" : "none";

                        arrPossession += '<tr>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><span class="possessionaway">' + valHome + '</span></td>';
                        arrPossession += '<td style="width: 15%; text-align: center; padding: 5px 0px;"><span id="timehome"><time>' + e.val().home + '</span></td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;">';
                        arrPossession += '<img title="Bắt đầu" onclick="starthomeAction()" style="height: 25px; width: 25px;cursor:pointer; display:' + checkt + ' " id="starthome" class="img_delete img_starthome" src="img/play.png" />';
                        arrPossession += '<img title="Dừng" style="height: 25px; width: 25px;cursor:pointer; display:' + checktforpause + '" class="img_delete img_pausehome" src="img/pausered.png"/>';
                        arrPossession += '</td>';
                        arrPossession += '<td style="width: auto; text-align: center; padding: 5px 0px;">Kiểm soát bóng</td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;">';
                        arrPossession += '<img title="Bắt đầu" onclick="startawayAction()" style="height: 25px; width: 25px;cursor:pointer;  display:' + checkaway + '" class="img_delete img_startaway" src="img/play.png"/>';
                        arrPossession += '<img title="Dừng" style="height: 25px; width: 25px;cursor:pointer; display:' + checkawayforpause + '" class="img_delete img_pauseaway" src="img/pausered.png"/>';
                        arrPossession += '</td>';
                        arrPossession += '<td style="width: 15%; text-align: center; padding: 5px 0px;"><span id="timeraway" ><time>' + e.val().away + '</time></span></td>';
                        arrPossession += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><span class="possessionaway">' + valAway + '</span></td>';
                        arrPossession += '</tr>';
                        arrPossession += '<tr><td colspan="8" style="padding: 5px 0px; text-align: center;"><img title="" onclick="pauseTime()" style="height: 40px; width: 40px;cursor:pointer;" class="img_delete" src="img/pausered.png"/></td></tr>';
                    }
                    else {
                        var validateKey = "";
                        if (e.key == "7corners") validateKey = "Phạt góc";
                        if (e.key == "3fouls") validateKey = "Phạm lỗi";
                        if (e.key == "0goals") validateKey = "Bàn thắng";
                        if (e.key == "6offsides") validateKey = "Việt vị";
                        if (e.key == "8possession") validateKey = "Kiểm soát bóng";
                        if (e.key == "5redcard") validateKey = "Thẻ đỏ";
                        if (e.key == "1shots") validateKey = "Cú sút";
                        if (e.key == "2shotsontarget") validateKey = "Cú sút trúng đích";
                        if (e.key == "4yellowcard") validateKey = "Thẻ vàng";
                        arrStr += '<tr>';
                        arrStr += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) - 1) + '\')" style="height: 25px; width: 25px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                        arrStr += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().home + '</td>';
                        arrStr += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'home\',\'' + e.key + '\',\'' + (Number(e.val().home) + 1) + '\')" style="height: 25px; width: 25px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                        arrStr += '<td style="width: auto; text-align: center; padding: 5px 0px;">' + validateKey + '</td>';
                        arrStr += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Giảm" onclick="updateGameDetails(\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) - 1) + '\')" style="height: 25px; width: 25px;cursor:pointer;" class="img_delete" src="img/remove.png"/></td>';
                        arrStr += '<td style="width: 15%; text-align: center; padding: 5px 0px;">' + e.val().away + '</td>';
                        arrStr += '<td style="width: 10%; padding: 5px 0px; text-align: center;"><img title="Tăng" onclick="updateGameDetails(\'away\',\'' + e.key + '\',\'' + (Number(e.val().away) + 1) + '\')" style="height: 25px; width: 25px;cursor:pointer;" class="img_delete" src="img/plus.png"/></td>';
                        arrStr += '</tr>';
                    }

                });
                arrStr = arrStr + arrPossession;
                arrStr += '  </table>';
                $('.wrapper_infor').html(arrStr);
            });
        }
        function pauseTime() {
            clearTimeout(t);
            clearTimeout(taway);
            t = null;
            taway = null;
            $('.img_starthome').css("display", "inline-block");
            $('.img_pausehome').css("display", "none");
            $('.img_startaway').css("display", "inline-block");
            $('.img_pauseaway').css("display", "none");
        }
        // Sửa Game
        function editGameDetails(Id) {
            gameId = Id;
            $('.wrapper_add_edit').css("display", "block");
            // Mặc định là đang trỏ vào hiệp 1
            getGameDetails('round1');
            $('.tablinks label').css("background", "#eee");
            $('.defaultlabel').css("background", "cadetblue");
        }
        function updateGameDetails(typeTeam, field, val) {
            if (round == "all" || finished == "1" || role == "viewer") {
                return;
            }
            if (Number(val) >= 0) {
                if (field == "2shotsontarget") // Nếu là cú sút trúng đích thì tự động thêm mới vào sút
                {
                    // Cập nhật cho tất cả


                    // Cập nhật cho trừng trường
                    var refOldShot = defaultDatabase.ref("games/" + gameId + "/" + round + "/1shots/" + typeTeam);
                    var Oldshot = 0;
                    refOldShot.on("value", function (snapshot) {
                        Oldshot = Number(snapshot.val());
                    });
                    var refShotsontarget = defaultDatabase.ref("games/" + gameId + "/" + round + "/2shotsontarget/" + typeTeam);
                    var newShotsontarget = 0;
                    refShotsontarget.on("value", function (snapshot) {
                        if (Number(val) > Number(snapshot.val())) {
                            newShotsontarget = Oldshot + 1;
                        }
                        else {
                            newShotsontarget = Oldshot - 1;
                        }
                    });
                    var refUdShots = defaultDatabase.ref("games/" + gameId + "/" + round + "/1shots/" + typeTeam).set(newShotsontarget);

                    // Cập nhật gia trị cả trận đấu
                    var valAll = 0;
                    var refRound1 = defaultDatabase.ref("games/" + gameId + "/round1/1shots/" + typeTeam);
                    refRound1.on("value", function (snap) {
                        valAll += Number(snap.val());
                    });
                    var refRound2 = defaultDatabase.ref("games/" + gameId + "/round2/1shots/" + typeTeam);
                    refRound2.on("value", function (snap) {
                        valAll += Number(snap.val());
                    });
                    var refAll = defaultDatabase.ref("games/" + gameId + "/all/1shots/" + typeTeam).set(valAll);
                }

                // Cập nhật gia trị cả trận đấu
                var refRound = defaultDatabase.ref("games/" + gameId + "/" + round + "/" + field + "/" + typeTeam).set(val);
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

                pushDetail(field, typeTeam);
            }

        }
        function updateGamePossession(typeTeam, val) {
            if (finished == "1" || round == "all" || role == "viewer") {
                return;
            }

            var refRound = defaultDatabase.ref("games/" + gameId + "/" + round + "/8possession/" + typeTeam).set(val);
            // Cập nhật thời gian cho cả 2 hiệp
            var secondsAll = 0, minutesAll = 0, hoursAll = 0;
            var secondRound1 = 0, secondRound2 = 0;
            var refRound1 = defaultDatabase.ref("games/" + gameId + "/round1/8possession/" + typeTeam);
            refRound1.on("value", function (snapshot) {
                var arrRound1 = snapshot.val().split(":");
                secondRound1 = (+arrRound1[0]) * 60 * 60 + (+arrRound1[1]) * 60 + (+arrRound1[2]);
            });
            var refRound2 = defaultDatabase.ref("games/" + gameId + "/round2/8possession/" + typeTeam);
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
            var refRound = defaultDatabase.ref("games/" + gameId + "/all/8possession/" + typeTeam).set(display);
        }
        function updateTimeMatch(val) {
            var refRound = defaultDatabase.ref("games/" + gameId + "/" + round + "/timematch").set(val);

            // Cập nhật thời gian cho cả 2 hiệp
            var secondsAll = 0, minutesAll = 0, hoursAll = 0;
            var secondRound1 = 0, secondRound2 = 0;
            var refRound1 = defaultDatabase.ref("games/" + gameId + "/round1/timematch");
            refRound1.on("value", function (snapshot) {
                var arrRound1 = snapshot.val().split(":");
                secondRound1 = (+arrRound1[0]) * 60 * 60 + (+arrRound1[1]) * 60 + (+arrRound1[2]);
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

        function add() {
            seconds++;
            if (seconds >= 60) {
                seconds = 0;
                minutes++;
                if (minutes >= 60) {
                    minutes = 0;
                    hours++;
                }
            }
            var display = (hours ? (hours > 9 ? hours : "0" + hours) : "00") + ":" + (minutes ? (minutes > 9 ? minutes : "0" + minutes) : "00") + ":" + (seconds > 9 ? seconds : "0" + seconds);
            updateGamePossession('home', display);
            $('#timehome').html(display);
            timer();
        }
        function timer() {
            clearTimeout(taway);
            t = setTimeout(add, 1000);
        }
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
        function addaway() {
            secondsaway++;
            if (secondsaway >= 60) {
                secondsaway = 0;
                minutesaway++;
                if (minutesaway >= 60) {
                    minutesaway = 0;
                    hoursaway++;
                }
            }
            var display = (hoursaway ? (hoursaway > 9 ? hoursaway : "0" + hoursaway) : "00") + ":" + (minutesaway ? (minutesaway > 9 ? minutesaway : "0" + minutesaway) : "00") + ":" + (secondsaway > 9 ? secondsaway : "0" + secondsaway);
            updateGamePossession('away', display);
            timeraway();
        }
        function timeraway() {
            clearTimeout(t);
            taway = setTimeout(addaway, 1000);
        }
        function addmatch() {
            secondsmatch++;
            if (secondsmatch >= 60) {
                secondsmatch = 0;
                minutesmatch++;
                if (minutesmatch >= 60) {
                    minutesmatch = 0;
                    hoursmatch++;
                }
            }
            var display = (hoursmatch ? (hoursmatch > 9 ? hoursmatch : "0" + hoursmatch) : "00") + ":" + (minutesmatch ? (minutesmatch > 9 ? minutesmatch : "0" + minutesmatch) : "00") + ":" + (secondsmatch > 9 ? secondsmatch : "0" + secondsmatch);
            updateTimeMatch(display);
            timermatch();
        }
        function timermatch() {
            tmatch = setTimeout(addmatch, 1000);
        }
        function stoptimermatch() {
            if (round == "all")
                return;
            tmatch = null;
            var refFinished = defaultDatabase.ref("games/" + gameId + "/" + round + "/finished").set("1");
            clearTimeout(tmatch);
        }
        function starttimermatch() {
            if (round == "all" || role == "viewer")
                return;
            tmatch = null;
            timermatch();
            $('.img_starttimermatch').css("display", "none");
            $('.img_stoptimermatch').css("display", "inline-block");
        }

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
        $('.homeclub').change(function () {
            if (role == "viewer")
                return;
            var valHome = $('.homeclub option:selected').text();
            var valAway = $('.awayclub option:selected').text();
            var refHome = defaultDatabase.ref("games/" + gameId + "/homename").set(valHome);
            var refnameMatch = defaultDatabase.ref("games/" + gameId + "/name").set(valHome + " vs " + valAway);
        });
        $('.awayclub').change(function () {
            if (role == "viewer")
                return;
            var valHome = $('.homeclub option:selected').text();
            var valAway = $('.awayclub option:selected').text();
            var refHome = defaultDatabase.ref("games/" + gameId + "/awayname").set(valAway);
            var refnameMatch = defaultDatabase.ref("games/" + gameId + "/name").set(valHome + " vs " + valAway);
        });
        $('.stadium').change(function () {
            if (role == "viewer")
                return;
            var valStadium = $('.stadium option:selected').text();
            var refStadium = defaultDatabase.ref("games/" + gameId + "/stadium").set(valStadium);
        });

        // Tắt bật kiểm soát bóng
        function starthomeAction() {
            if (finished == "1" || round == "all") {
                return;
            }

            timer();
            taway = null;
        }

        function startawayAction() {
            if (finished == "1" || round == "all") {
                return;
            }

            timeraway();
            t = null;
        }
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
        // $('.img_starthome').click(function(){
        //   alert(1111);
        //
        // });


        // $('.nameMatch').change(function(){
        //   var nameMatch = $('.nameMatch').val();
        //   var refnameMatch = defaultDatabase.ref("games/"+gameId+"/name").set(nameMatch);
        // });
        // $.datetimepicker.setLocale('pt-BR');
        // $('.timeStart').datetimepicker();

     </script>
    </form>
</body>
</html>
