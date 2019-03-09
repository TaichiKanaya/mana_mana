# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Pickadateの日本語化
options = {
    monthsFull : ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    monthsShort : ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    weekdaysFull : ['日曜', '月曜', '火曜', '水曜', '木曜', '金曜', '土曜'],
    weekdaysShort : ['日曜', '月曜', '火曜', '水曜', '木曜', '金曜', '土曜'],
    today : '本日',
    clear : '入力元をクリア',
    close : '閉じる'
    format : 'yyyy/mm/dd'
}
jQuery.extend(jQuery.fn.pickadate.defaults, options)
