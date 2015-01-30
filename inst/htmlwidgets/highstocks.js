HTMLWidgets.widget({

  name: 'highstocks',

  type: 'output',

  initialize: function(el, width, height) {
      var id = el.id
    return {
	id: id
    }

  },

  renderValue: function(el, x, instance) {
      console.log('el = '+el.id);
      console.log('x.data = '+JSON.stringify(x.data));
      console.log(instance);
      console.log(x.data);

      
      data = x.data;
      var data = _.map(data,function(x){
	  x.data = HTMLWidgets.dataframeToD3(x.data);
	  return(x);
      })

      $('#'+el.id)
	  .highcharts("StockChart",{
	      // chart: x.chartOpts,
	      // rangeSelector: {
	      // 	  selected: 1
	      // },

	      series: data,
              title: {
		  text: x.title
              },
	      legend: {
		  enabled: true
	      },
              // xAxis: x.xAxis,
              // yAxis: x.yAxis,
	      // credits: x.creditsOpts,
	      // exporting: x.exportingOpts,
	      plotOptions: {
		  line: {
		      turboThreshold:10000
		  }
	      }
	  });

  },

  resize: function(el, width, height, instance) {

  }
});





// // TESTS
// data = [
//     {
// 	"name": "series1",
// 	"data": [                 4,                 4,                 5 ] 
//     },
//     {
// 	"name": "series2",
// 	"data": [                 1,                 2,                 3 ] 
//     } 
// ]



              // series: [{
	      //     name: 'Crazy stuff',
	      //     data: data
              // }]
              // series: [{
	      //     name: 'Crazy stuff',
	      //     data: [
	      // 	  {y:1,
	      // 	   name: 'point 1'},
	      // 	  {y:3},
	      // 	  {y:4}
	      //     ]
              // }]
              // series: [{
	      //     name: 'Jane',
	      //     data: [1, 6, 4]
              // }]
	      // {
	      //     name: 'John',
	      //     data: [5, 7, 3]
              // }]
