command: "/bin/echo 1 &> /dev/null"
refreshFrequency: 10000000
render: (output) -> """
  <b class="right bottom" id="inverter">#{output}</b>
"""

afterRender: (domEl) ->
  button = $(domEl).find '#inverter'
  $(domEl).addClass button.get(0).className
  button.unbind 'click'
  button.on 'click', (ev) =>
    invertedKey = 'com.brettterpstra.uberInverted'
    inv = localStorage.getItem invertedKey
    if !inv || inv == null || inv == ""
      inv = 1
    else
      inv = parseInt inv, 10
      inv = inv * -1

    if (inv == 1)
      $('body').addClass 'inverted'
    else
      $('body').removeClass 'inverted'
    # @run('osascript inverter.widget/togglejacket.applescript')
    localStorage.setItem invertedKey, inv


style: """
  border none
  right -54px
  bottom -54px
  width 100px
  height 100px
  z-index 1000

  &.top
    bottom auto
    top -50px

  &.left
    right auto
    left -54px

  body.inverted & b
    border solid 2px rgba(147, 164, 167, .2)
    background radial-gradient(rgba(255, 255, 255, .5), rgba(0, 0, 0, .1));
    -webkit-filter saturate(10%)
    &:hover
      border-color: rgba(147, 164, 167, .4)
  b
    display block
    width 100%
    height 100%
    border-radius 100px
    background radial-gradient(rgba(0, 0, 0, .5), rgba(0, 0, 0, .1));
    border-style solid
    border-width 2px
    border-color rgba(200,200,200,.2)
    opacity .95
    transition all .15s ease-out
    -webkit-transform rotate(45deg)

    &:hover
      border-color rgba(200,200,200,.4)
      -webkit-transform scale(2.5) rotate(45deg)
      -webkit-filter saturate(100%)
      border-radius 0
      border-width 1px !important


"""
