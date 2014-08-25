# Note that animation is cpu-intensive, especially
# with a large number of bars
settings:
  background: true
  color: true
  brighter: false
  inverse: false
  bars: 100
  animated: false

colors:
  low: "rgb(60, 160, 189)"
  normal: "rgb(88, 189, 60)"
  high: "rgb(243, 255, 134)"
  higher: "rgb(255, 168, 80)"
  highest: "rgb(255, 71, 71)"

command: "sysctl -n vm.loadavg|awk '{print $2}'"
refreshFrequency: 10000
render: (output) -> """
  <div id="chartcontainer"></div>
"""

update: (output, domEl) ->

  max_rows = @settings.bars
  $el = $(domEl)
  $chart = $el.find('#chartcontainer')

  $el.css
    width: @settings.bars * 6.3 + 'px'
  # Adjust classes based on settings
  if @settings.background
    $el.addClass('bg')
  if @settings.animated
    $el.addClass('animated')
  if @settings.color
    $el.addClass('color')
  if @settings.brighter
    $el.addClass('brighter')
  if @settings.inverse
    $el.addClass('inverse')

  # If the chart container is empty, set up bars
  if $chart.find('.bar').length != max_rows
    $chart.empty()
    i = 0
    while i < max_rows
      $chart.append('<div class="bar">')
      i++

  # Load previously-stored values from LocalStorage to array
  storageKey = 'com.brettterpstra.loadArray2'
  totals = JSON.parse(localStorage.getItem(storageKey))
  if totals == null
    totals = []

  # Add the current load result to the load values array
  totals.push(output.replace(/\n/g,''))

  # Store the ammended array
  localStorage.setItem(storageKey, JSON.stringify(totals))

  # Trim the array to match the number of bars we want
  totals = totals.slice(-max_rows)
  # Turn array strings into floating point values
  totals = totals.map (v, a, i) ->
    parseFloat(v)

  # Create a new array and sort it to determine min/max values
  sorted = totals.slice(0)
  sorted.sort (a,b) ->
    a-b
  max = sorted[sorted.length - 1]
  min = sorted[0]
  div = (max - min) / (1000 / max_rows)

  # TODO: A setting to use a set scale from 0 and just remove the first bar and add the last one
  # Iterate the values array and assign height and color classes to bars
  i = 0
  while i < max_rows
    load = totals[i]
    value = ((load - min) / div)

    $bar = $($chart.find('div').get(i))
    if load != undefined
      $bar.html("<p></p>")
    $bar.css
      paddingTop: value + '%'
      left: (i * 6) + 'px'
    colorclass = switch
      when load > 10 then 'urgent'
      when load > 7 then 'important'
      when load > 4 then 'high'
      when load > 2 then 'normal'
      else 'low'
    $bar.removeClass "urgent important high normal"
    $bar.addClass colorclass
    i++

style: """
  left 600px
  top 90px
  width 315px
  height 90px
  border-radius 5px
  position relative

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


  .bar
    color rgba(255,255,255,.65)
    font-size 10px
    text-align center
    display block
    font-family Menlo
    border-left 3px solid rgb(255,255,255)
    width 5px
    bottom 0
    padding 0
    line-height 1
    position absolute

  &.animated .bar
    -webkit-backface-visibility hidden;
    -webkit-perspective 1000;
    -webkit-transform translate3d(0, 0, 0);
    transition all 4s linear

  color-low = #{@colors.low}
  color-normal = #{@colors.normal}
  color-high = #{@colors.high}
  color-important = #{@colors.higher}
  color-urgent = #{@colors.highest}

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
