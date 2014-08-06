#date picker for /orientations/new
jQuery ->
  $("#from_date").datepicker dateFormat: "yy-mm-dd"
  $("#to_date").datepicker dateFormat: "yy-mm-dd"
  $("#class_date").datepicker dateFormat: "yy-mm-dd"
  $("#registration_date").datepicker dateFormat: "yy-mm-dd"
  $("#orientation_class_time").timepicker({ 
	  minTime: new Date(0, 0, 0, 8, 0, 0), #sets default time ranges in this case 8am to 8pm (military time)
  	maxTime: new Date(0, 0, 0, 20, 0, 0) #see http://jsfiddle.net/wvega/Gczvz/embedded/result,js,html,css,resources/
	 })

#date validation on /orientations/new
jQuery ->
	to_date = null
	from_date = null
	$("#to_date, #from_date").bind "change", ->
		from_date = new Date($('#from_date').val())
		to_date = new Date($('#to_date').val())
		if from_date > to_date
			$("#date_error").text("Error! Not a valid date range")
			$("#submit_button input").attr("disabled", true)
		else
			$("#date_error").text("")
			$("#submit_button input").attr("disabled", false)
#show/hide to date and days to exclude
jQuery ->
	$("#from_date_text").text("Single Date")
	$(".multiple_dates").hide()
	$("#selection_repeating").click ->
		$("#from_date_text").text("From Date")
		$(".multiple_dates").show()
	$("#selection_single").click -> #when user clicks on single we...
		$("#from_date_text").text("Single Date") #change text back to single date
		$(".multiple_dates").hide() #hide to date and days to exclude
		$('#to_date').val("") #clear to_date field
		$("#submit_button input").attr("disabled", false) #re-enable submit button
