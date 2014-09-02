colors =
  low    : "rgb(60, 160, 189)"
  normal : "rgb(88, 189, 60)"
  high   : "rgb(243, 255, 134)"
  higher : "rgb(255, 168, 80)"
  highest: "rgb(255, 71, 71)"

settings:
  background: true
  color     : true
  brighter  : false
  inverse   : false
  bars      : 100
  animated  : true

command: "sysctl -n vm.loadavg|awk '{print $2}'"

refreshFrequency: 10000

style: """
  left 600px
  top 85px
  width 315px
  height 90px
  line-height: @height
  border-radius 5px

  &.bg
    background rgba(0,0,0,.25)

  &.inverse
    &.bg
      background rgba(255,255,255,.25)
    .bar
      border-left 3px solid rgb(0,0,0)

  #chartcontainer
    position absolute
    bottom 0
    width 100%
    height 100%
    left 10px
    font-size 0
    transform-origin 50% 100%
    overflow hidden

  .bar
    color rgba(255,255,255,.65)
    display inline-block
    vertical-align bottom
    border-left 3px solid rgb(255,255,255)
    width 2px
    padding 0
    height 1px
    transform-origin 50% 100%

  &.animated .bar
    -webkit-backface-visibility hidden;
    -webkit-perspective 1000;
    -webkit-transform translate3d(0, 0, 0);
    transition all 500ms linear

  color-low = #{colors.low}
  color-normal = #{colors.normal}
  color-high = #{colors.high}
  color-important = #{colors.higher}
  color-urgent = #{colors.highest}

  &.color
    .low
      border-left-color color-low

    .normal
      border-left-color color-normal

    .high
      border-left-color color-high

    .important
      border-left-color color-important

    .urgent
      border-left-color color-urgent

  .bar
    opacity .4

  &.brighter .bar
    opacity 1
"""


render: (output) -> """
  <div id="chartcontainer"></div>
"""

afterRender: (domEl) ->
  # clean old storage
  localStorage.removeItem('com.brettterpstra.loadArray2')

  el = $(domEl)
  @$chart = $(domEl).find('#chartcontainer')
  @chartHeight = @$chart.height() - 10 # leave some padding at the top

  el.addClass('bg')       if @settings.background
  el.addClass('animated') if @settings.animated
  el.addClass('color')    if @settings.color
  el.addClass('brighter') if @settings.brighter
  el.addClass('inverse')  if @settings.inverse

  el.css width: @settings.bars * 5 + 18


update: (output, domEl) ->
  # figure out new max load
  load  = parseFloat output.replace(/\n/g,'')
  max   = Math.max.apply(Math, @loads)
  max   = Math.max load, max

  # resize all bars if necessary
  bars = @$chart.children()
  if max != @prevMax
    @setBarHeight(bar, @loads[i], max) for bar, i in bars
    @prevMax = max

  # store current load
  @loads.push load

  # create new bar
  ($bar = $('<div class="bar">'))
    .addClass @colorClass(load)

  # remove old bars and loads
  if bars.length >= @settings.bars
    @loads.shift()
    $(bars[0]).remove()

  # render
  @$chart.append $bar
  requestAnimationFrame =>
    @setBarHeight($bar[0], load, max)

colorClass: (load) ->
  switch
    when load > 10 then 'urgent'
    when load > 7 then 'important'
    when load > 4 then 'high'
    when load > 2 then 'normal'
    else 'low'

setBarHeight: (bar, load, max) ->
  bar.style.webkitTransform = "scale(1, #{@chartHeight * load / max})"

loads: []
prevMax: null
