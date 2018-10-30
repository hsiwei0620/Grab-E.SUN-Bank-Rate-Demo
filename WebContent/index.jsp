<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>E.SUN BANK Rates Demo</title>

<!-- include line chart -->
<link id="themecss" rel="stylesheet" type="text/css" href="//www.shieldui.com/shared/components/latest/css/light-bootstrap/all.min.css" /> 
<script type="text/javascript" src="js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="//www.shieldui.com/shared/components/latest/js/shieldui-all.min.js"></script>

<!-- include date selector js and css -->
<script type="text/javascript" charset="UTF-8" src="js/jscal2.js"></script>
<script type="text/javascript" charset="UTF-8" src="js/cn.js"></script>
<link rel="Stylesheet" type="text/css" href="css/jscal2.css" />

<script type="text/javascript">
	$(document).ready(function() {

		var time = [];
		var buyRate = [];
		var sellRate = [];
		
		//Get Rates Data
		$('#submit').click(function() {
			var countryId = $('#countryId').val();
			$.ajax({
				type : 'POST',
				url : 'GrapE_SUNRate',
				dataType : "json",
				data : $("#formId").serialize(),
				async : false,
				success : function(result) {
					$.each(result, function(idx, obj) {
						time[idx] = obj.Time;
						buyRate[idx] = obj.BuyRate;
						sellRate[idx] = obj.SellRate;
					});
				},
				error : function(xhr, ajaxOptions, thrownError) {
					alert(xhr.status + "\n" + thrownError + "\nSelect Data Not Completely" );
				}
			})

			showLineChart();
		});
		
		//Set Line Chart 
		function showLineChart() {

			var countryId = document.getElementById("countryId").value;
			
			$("#chart").shieldChart({
				theme : "bootstrap",
				exportOptions : {
					image : false,
					print : false
				},
				axisX : {
					categoricalValues : time,
					ticksRepeat:25 //only evety n-th tick will be rendered.
				},
				axisY : {
					axisTickText : {
						format : "{text:c}"
					},
					title : {
						text : countryId + "即期"
					}
				},
				tooltipSettings : {
					chartBound : true
				},
				seriesSettings : {
					line : {
						enablePointSelection : true,
						pointMark : {
							activeSettings : {
								pointSelectedState : {
									drawWidth : 4,
									drawRadius : 4
								}
							}
						}
					}
				},
				primaryHeader : {
					text : countryId + "匯率"
				},
				dataSeries : [ {
					seriesType : 'line',
					collectionAlias : '賣匯',
					data : buyRate
				}, {
					seriesType : 'line',
					collectionAlias : '買匯',
					data : sellRate
				} ]
			});
		}
	})
</script>
</head>

<body class="theme-light">
	<form id="formId">
		<p>
			Country: <select id="countryId" name="countryId" size="3">
				<option value="USD">美元(USD)</option>
				<option value="CNY">人民幣(CNY)</option>
				<option value="AUD">澳幣(AUD)</option>
				<option value="ZAR">南非幣(ZAR)</option>
				<option value="NZD">紐西蘭幣(NZD)</option>
			</select>
		
			Start Date: <input id="startDate" name="startDate" type="text"/>&nbsp;
			<img id='imgpicchkdat' src="image/calendar_month.png" align="middle"/>
                    <script type="text/javascript">
                        Calendar.setup({
                            inputField: "startDate",
                            trigger: "imgpicchkdat",
                            dateFormat: "%Y-%m-%d",
                            onSelect: function() { this.hide(); }
                        });</script>
                
                        
            End Date: <input id="endDate" type="text" name="endDate"/>&nbsp;  
			<img id='imgpicchkdat2' src="image/calendar_month.png" align="middle"/>
                    <script type="text/javascript">
                        Calendar.setup({
                            inputField: "endDate",
                            trigger: "imgpicchkdat2",
                            dateFormat: "%Y-%m-%d",
                            onSelect: function() { this.hide(); }
                        });</script>
			
		Submit: <input type="button" id="submit" name="submit" value="submit" />
		</p>
	</form>

	<div id="chart"></div>

</body>
</html>