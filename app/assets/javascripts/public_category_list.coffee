# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
options = {
  now: moment().toDate()
  max: moment().toDate()
  selectYears: true
}

# 公開日設定
$('#condition_fromRegDate').pickadate(options)
$('#condition_toRegDate').pickadate(options)