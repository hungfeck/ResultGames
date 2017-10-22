<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="ResultGame.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đăng nhập</title>
    <meta charset="utf-8" />
    <link href="css/new-age.css" rel="stylesheet"/>
    <link rel="stylesheet" href="vendor/font-awesome/css/font-awesome.min.css" />
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-app.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-auth.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-database.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-firestore.js"></script>
	<script src="https://www.gstatic.com/firebasejs/4.5.0/firebase-messaging.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="module form-module wrapper_login" id="wrapper_login">
        <div class="login">
            <div class="toggle">
                <i class="fa fa-times fa-window-close"></i>
            </div>
            <div class="form">
            <%--<h2 style="text-align: center;">Đăng nhập</h2>--%>
         <%--   <asp:TextBox ID="txtUsername" CssClass="username" placeholder="Tài khoản" runat="server"></asp:TextBox>
            <asp:TextBox  ID="txtPassword" CssClass="password" placeholder="Mật khẩu" runat="server" TextMode="Password"></asp:TextBox>--%>
            <input type="text" placeholder="Tài khoản" class="username"/>
            <input type="password" placeholder="Mật khẩu" class="password"/>
            <span class="loginfail" style="color:#D80027; padding-bottom: 10px; display: none; text-align: center;">Sai tài khoản hoặc mật khẩu</span>
            <%--<asp:Button ID="btn_login" Text="Đăng nhập" style="margin:0px;" CssClass="btn_login" runat="server" OnClick="btn_login_Click"/>--%>
                <input type="button" value="Đăng nhập" class="btn_login"/>
            <%--<button class="btn_login">Đăng nhập</button>--%>
            </div>
        </div><!--.login-->
    </div>
        <script>
            var config = {
                apiKey: "AIzaSyBpawnGQ1WPtyOHODWAxuyG9dy9yuUThOY",
                authDomain: "resultsgame.firebaseapp.com",
                databaseURL: "https://resultsgame.firebaseio.com",
                projectId: "resultsgame",
                storageBucket: "resultsgame.appspot.com",
                messagingSenderId: "1080413171479"
            };
            var defaultApp = firebase.initializeApp(config);
            var defaultDatabase = defaultApp.database();
            var username = "", password = "", role = "";
            $('.btn_login').click(function () {
                var txtUsername = $.trim($('.username').val());
                var txtPassword = $.trim($('.password').val());
                if (txtUsername == null || txtUsername == '' || txtUsername == 'Tài khoản') {
                    alert('Bạn phải nhập tài khoản');
                    e.preventDefault();
                    e.stopPropagation();
                    return;
                }
                if (txtPassword == null || txtPassword == '' || txtPassword == 'Mật khẩu') {
                    alert('Bạn phải nhập mật khẩu');
                    e.preventDefault();
                    e.stopPropagation();
                    return;
                }
                var ref = defaultDatabase.ref("users");
                
                ref.on("value", function (snapshot) {
                    snapshot.forEach(function (e) {
                        if (e.val().username == txtUsername && e.val().password == txtPassword) {
                            username = e.val().username;
                            password = e.val().password;
                            role = e.val().role;
                        }
                    });
                    if (username == "") {
                        $('.loginfail').css("display", "block");
                        return;
                    }
                    var params = { 'username': username, 'password': password, 'role': role };
                    $.ajax
                    ({
                        type: "POST",
                        url: "Handlers/login.ashx",
                        data: params,
                        async: false,
                        dataType: 'json',
                        success: function (data) {
                            if (data != null) {
                                window.location.href = "index.aspx";
                            }
                            else {
                                alert('Có lỗi trong quá trình đăng nhập!');
                            }
                        },
                        error: function (result) {
                            alert('Có lỗi trong quá trình đăng nhập!');
                        }
                    });
                });
                
                
                //e.preventDefault();
                //e.stopPropagation();
                //$('.wrapper_login').css("display", "none");
                //$('.loginfail').css("display", "none");
            });
        </script>
    </form>
</body>
</html>
