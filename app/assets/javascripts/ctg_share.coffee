# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
options = {
  now: moment().add(-39,'year').toDate()
  max: moment().toDate(),
  selectYears: true
}

# 生年月日設定
$('#birthday').pickadate(options)