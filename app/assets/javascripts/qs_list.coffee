# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
var calendars = bulmaCalendar.attach('[type="date"]', options);

for(var i = 0; i < calendars.length; i++) {
  calendars[i].on('date:selected', date => {
    console.log(date);
  });
}