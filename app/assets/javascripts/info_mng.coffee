# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
options = {
  now: moment().toDate()
  max: moment().add(3,'year').toDate()
  selectYears: true
}

# 公開日設定
$('#announceDate_1').pickadate(options)
$('#announceDate_2').pickadate(options)
$('#announceDate_3').pickadate(options)