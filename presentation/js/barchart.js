
var bardata = [];

for (var i=0; i< 100; i++){
        bardata.push(Math.round(Math.random()*30)+10)
    }

/*    d3.tsv('data.tsv', function(data){
        for (key in data) {
            bardata.push(data[key].value)
        }*/

var margin = {top: 30, right: 30, bottom: 40, left: 50}

var height = 400 - margin.top - margin.bottom,
    width = 600 - margin.left - margin.right,
    barWidth = 50,
    barOffset = 5;

var tempColor;

var colors = d3.scale.linear()
    .domain([0, bardata.length*.25, bardata.length*.75, bardata.length])
    .range(['#FFB832',"#C61C6F","#268BD2","#85992C"])

var yScale = d3.scale.linear()
    .domain([0, d3.max(bardata)])
    .range([0, height]);

var xScale = d3.scale.ordinal()
    .domain(d3.range(0,bardata.length))
    .rangeBands([0,width], 0.1);

var tooltip = d3.select('body').append('div')
        .attr('id','mytip')
        .style('position','absolute')
        .style('padding', '0 10px')
        .style('background', 'white')
        .style('opacity', 0)

var myChart = d3.select('#chart').append('svg')
    .style('background','#E7E0CB')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', 'translate(' + margin.left + ', ' + margin.top + ')')
    /*.style('background', '#C9D7D6')*/
    .selectAll('rect').data(bardata)
    .enter().append('rect')
        .style('fill',function(d ,i ){
            return colors(i);
        })
        .attr('width', xScale.rangeBand())
        .attr('x', function(d, i){
            return xScale(i);
        })
        .attr('height', 0)
        .attr('y', height)

    /* EVENTS */
    .on('mouseover', function(d){

        tooltip.transition()
            .style('opacity', .9)

        tooltip.html(d)
            .style('left',(d3.event.pageX) + 'px')
            .style('top', (d3.event.pageY) + 'px')
            .style('position', 'absolute')
            .style('font-size','2.5em')
            .style('z-index', '1')

        tempColor = this.style.fill;
        d3.select(this)
            /*.transition()*/
            .style('opacity', 0.5)
            .style('fill', 'yellow')
        })
    .on('mouseout', function(d){

        tooltip.html('')
            .style('hidden','true')

        d3.select(this)
            /*.transition()*/
            .style('opacity', 1)
            .style('fill', tempColor)

    })






myChart.transition()
    .attr('height', function(d){
        return yScale(d);
    })
    .attr('y', function(d) {
        return height - yScale(d);
    })
    .delay(function(d, i){
            return i * 50;
    })
    .duration(300)
    .ease("elastic")

var vGuideScale = d3.scale.linear()
    .domain([0, d3.max(bardata)])
    .range([height, 0])

var vAxis = d3.svg.axis()
    .scale(vGuideScale)
    .orient('left')
    .ticks(10)

var vGuide = d3.select('svg').append('g')
    vAxis(vGuide)
    vGuide.attr('transform','translate(' + margin.left + ',' + margin.top + ')')
    vGuide.selectAll('path')
        .style({fill: 'none', stroke: '#000'})
    vGuide.selectAll('line')
        .style({stroke: '#000'})

var hAxis = d3.svg.axis()
    .scale(xScale)
    .orient('bottom')
    .tickValues(xScale.domain().filter(function(d,i){
        return !(i % (bardata.length/5));
    }))

var hGuide = d3.select('svg').append('g')
    hAxis(hGuide)
    hGuide.attr('transform','translate(' + margin.left + ',' + (height + margin.top) + ')')
    hGuide.selectAll('path')
        .style({fill: 'none', stroke: '#000'})
    hGuide.selectAll('line')
        .style({stroke: '#000'})
