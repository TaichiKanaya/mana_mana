// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
document.addEventListener('DOMContentLoaded', function() {
	// Get all "navbar-burger" elements
	var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

	// Check if there are any nav burgers
	if ($navbarBurgers.length > 0) {

		// Add a click event on each of them
		$navbarBurgers.forEach(function($el) {
			$el.addEventListener('click', function() {

				// Get the target from the "data-target" attribute
				var target = $el.dataset.target;
				var $target = document.getElementById(target);

				// Toggle the class on both the "navbar-burger" and the "navbar-menu"
				$el.classList.toggle('is-active');
				$target.classList.toggle('is-active');

			});
		});
	}

	/* Pickadateの日本語化 */
	jQuery.extend(jQuery.fn.pickadate.defaults, {
		monthsFull : ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
		monthsShort : ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
		weekdaysFull : ['日曜', '月曜', '火曜', '水曜', '木曜', '金曜', '土曜'],
		weekdaysShort : ['日曜', '月曜', '火曜', '水曜', '木曜', '金曜', '土曜'],
		today : '本日',
		clear : '入力元をクリア',
		format : 'yyyy/mm/dd'
	});

	/**
	 * 桁数が1桁だったら先頭に0を加えて2桁に調整する
	 * @param int num 対象数字
	 */
	function setfig(num) {
		var ret;
		if (num < 10)
			ret = "0" + num;
		else
			ret = num;
		return ret;
	}

	/**
	 * ただいまの時間を算出
	 */
	function getNow() {
		nowTime = new Date();
		nowYear = setfig(nowTime.getFullYear());
		nowMonth = setfig(nowTime.getMonth() + 1);
		nowDate = setfig(nowTime.getDate());
		nowHour = setfig(nowTime.getHours());
		nowMin = setfig(nowTime.getMinutes());
		nowSec = setfig(nowTime.getSeconds());
		dayOfWeek = nowTime.getDay();
		dayOfWeekStr = [ "日", "月", "火", "水", "木", "金", "土" ][dayOfWeek];
		if (dayOfWeek == 0) {
			dayOfWeekColor = "red";
		} else if (dayOfWeek == 6) {
			dayOfWeekColor = "blue";
		} else {
			dayOfWeekColor = "black";
		}
		msg = nowYear + "/" + nowMonth + "/" + nowDate + " (<span style='color:" + dayOfWeekColor + "'>" + dayOfWeekStr + "</span>) " + nowHour + ":" + nowMin + ":" + nowSec;
		document.getElementById("RealtimeClockArea").innerHTML = msg;
	}

	// ただいまの時間を設定
	if (document.getElementById("RealtimeClockArea") != undefined) {
		getNow();
		setInterval(getNow, 1000);
	}
});
