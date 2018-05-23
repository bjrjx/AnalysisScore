<%--
  Created by IntelliJ IDEA.
  User: 84975
  Date: 2018/3/12
  Time: 22:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>$Title$</title>
    <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>
    <link href="lib/layui/css/layui.css" rel="stylesheet">
    <link href="css/collegeListStyle.css?version=2018.5.21" rel="stylesheet">
    <script src="lib/layui/layui.js"></script>
</head>
<body>
Hello!
<div class="college-info-header">

</div>
<div class="layui-container">
    <div class="college-info-list-sreach">
        <strong>高校所在地：</strong>
    </div>
    <div class="college-info-list-wrap"></div>
    <div id="college-info-list-laypage"></div>
</div>
</body>
<script>

    function refreshProvince(data){
        var value = JSON.parse(data);
        console.log(value);
        var dom = $('.college-info-list-sreach');
        dom.append('<a class="select">全部</a>');
        $.each(value, function(index){
           var a = '<a>' + value[index] + '</a>';
           dom.append(a);
        });

    }

    function refreshCollegelist(data) {
        var value = JSON.parse(data);
        console.log(value);
        $.each(value, function (index) {
            var wrapDiv = $('<div class="college-info-list"></div>');
            var nodeDiv1 = $('<div class="college-info-list-left"><a href=""><img src="' + value[index].badge + '" /></a><strong><a href="">' + value[index].name + '</a></strong></div>');
            var nodeDiv2 = $('<div class="college-info-list-center"></div>');
            var nodeUl = $('<ul><li>高校所在地：' + value[index].province + '</li><li>院校特色：' + value[index].type + '</li><li>博士点：' + value[index].doctor + '个</li><li>高校隶属：' + value[index].belong + '</li><li>硕士点：' + value[index].master + '个</li><li>学校网址：<a target="_blank" href="' + value[index].collegesite + '">' + value[index].collegesite + '</a></li></ul>');
            nodeDiv2.append(nodeUl);
            wrapDiv.append(nodeDiv1);
            wrapDiv.append(nodeDiv2);
            $('.college-info-list-wrap').append(wrapDiv);
            if (index == 0) {
                $('.college-info-list-left').css('border-top', '1px solid #E1E1E1');
                $('.college-info-list-center').css('border-top', '1px solid #E1E1E1');
            }
        });
    }

    function feshLayuipage() {
        layui.use('laypage', function () {
            var laypage = layui.laypage;
            var province = encodeURIComponent($('.select').text());
            var count;
            function freshCount(data) {
                request({}, 'POST', '/collegelist/getNum?province=' + province,refreshCount)
            }
            function refreshCount(data) {
                count =  data;
            }
            freshCount();
            //执行一个laypage实例
            laypage.render({
                elem: 'college-info-list-laypage' //注意，这里的 test1 是 ID，不用加 # 号
                , count:  count//数据总数，从服务端得到
                , first: '首页'
                , last: '尾页'
                , prev: '<em class="layui-icon">&#xe65a;</em>'
                , next: '<em class="layui-icon">&#xe65b;</em>'
                , jump: function (obj) {
                    freshCollegelist(obj.curr);
                }
            });
        });
    }

    function freshProvince(data){
        request({}, 'POST', '/provincelist/getProvince', refreshProvince);
    }

    function freshCollegelist(data) {
        $('.college-info-list-wrap').html('');
        var province = encodeURIComponent($('.select').text());
        console.log(province);
        request({}, 'POST', '/collegelist/getCollege?start=' + data + '&end=5&province=' + province, refreshCollegelist);
    }

    freshProvince();

    feshLayuipage();

    $('.college-info-list-sreach a').on('click', function () {
        $('.college-info-list-sreach a').removeClass('select');
        $(this).addClass('select');
        feshLayuipage();
    });

    function request(object, method, methodURL, successFunction) {
        $.ajax({
            url: methodURL,
            type: method,
            data: JSON.stringify(object),
            contentType: "application/json",
            dataType: "json",
            async: false,
            success: successFunction,
            error: function (data) {
                console.log('error!');
            }
        });
    }
</script>
</html>
