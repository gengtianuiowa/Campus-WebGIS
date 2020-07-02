<%@ page language="java" import="java.util.*" import="java.sql.*"  pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta charset="utf-8">
    <title>ECharts</title>
     <script src="http://echarts.baidu.com/build/dist/echarts-all.js"></script>
</head>
<body>
    <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="chart" style="height:400px;width:600px"></div>
     <script type="text/javascript">
         var myChart = echarts.init(document.getElementById('chart')); 
        
        option = {
    title : {
        text: '建筑物数量统计',
        subtext: '来源：GeoServer',
        x:'center'
    },
    tooltip : {
        trigger: 'item',
        formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
    legend: {
        orient : 'vertical',
        x : 'left',
        data:['教学楼','图书馆','院办','门','操场']
    },
    toolbox: {
        show : true,
        feature : {
            mark : {show: true},
            dataView : {show: true, readOnly: false},
            magicType : {
                show: true, 
                type: ['pie', 'funnel'],
                option: {
                    funnel: {
                        x: '25%',
                        width: '50%',
                        funnelAlign: 'left',
                        max: 1548
                    }
                }
            },
            restore : {show: true},
            saveAsImage : {show: true}
        }
    },
    calculable : true,
    series : [
        {
            name:'访问来源',
            type:'pie',
            radius : '55%',
            center: ['50%', '60%'],
            data:[
                {value:335, name:'教学楼'},
                {value:310, name:'图书馆'},
                {value:234, name:'院办'},
                {value:135, name:'门'},
                {value:1548, name:'操场'}
            ]
        }
    ]
};
        // 为echarts对象加载数据 
        myChart.setOption(option); 
    </script>
</body>
</html>
