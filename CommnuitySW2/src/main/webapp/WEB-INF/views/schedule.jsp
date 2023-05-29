<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.scheduler.dto.ScheduleDTOImpl" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
List<ScheduleDTOImpl> list = (ArrayList<ScheduleDTOImpl>)request.getAttribute("showSchedule");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>캘린더</title>
<link href='/docs/dist/demo-to-codepen.css' rel='stylesheet' />
  <style>

    html, body {
      margin: 0;
      padding: 0;
      font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
      font-size: 14px;
    }

    #calendar {
      max-width: 1100px;
      margin: 40px auto;
    }
    
    .add-button{
    	position: absolute;
    	top: 1px;
    	right: 230px;
    	background: #2C3E50;
    	border: 0;
    	color: white;
    	height: 35px;
    	border-radius: 3px;
    	width: 157px;
    }

  </style>


	<script src="./resources/js/firebaseDB.js"></script>     
    <script src="https://www.gstatic.com/firebasejs/4.10.1/firebase.js"></script>
	<script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js"></script>
	<script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-database.js"></script>
	<script src="https://www.gstatic.com/firebasejs/8.10.1/firebase-firestore.js"></script>
	<script src="https://www.gstatic.com/firebasejs/7.6.0/firebase-auth.js"></script>
	<script src="./resources/js/jquery.js"></script>
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.5/index.global.min.js'></script>
	<script src='/docs/dist/demo-to-codepen.js'></script>
	<script src="./resources/js/getSchedule.js"></script>
<script>

	var firebaseDatabase;

	// Initialize Firebase
	var app = firebase.initializeApp(firebaseConfig);

	const db = app.firestore();
	let documents;
	
	async function fetchDocumentsBetweenDates(userUID,start,end) {
		  try {
			const querySnapshot = await db.collection('schedules').doc(userUID).collection('schedule')
			.where("startDate", ">=", start)
		    .where("startDate", "<", end)
		    .get();
		   
		    //모든 문서 출력
		    documents = querySnapshot.docs.map((doc) => doc.data());
		    getScheduleInfo(documents,start,end);

		    console.log(JSON.stringify(documents));
		    console.log("문서 조회 완료");
		  } catch (error) {
		    console.error("문서 조회 중 오류 발생:", error);
		  }
		}	
	document.addEventListener('DOMContentLoaded', function() {
    	var calendarEl = document.getElementById('calendar');

    	var calendar = new FullCalendar.Calendar(calendarEl, {
      		selectable: true,
      		headerToolbar: {
        		left: 'prev,next today',
        		center: 'title',
        		right: 'dayGridMonth,timeGridWeek'
      		},
      		locale:"ko",
      		dayMaxEvents: true,
      		events: [
    	  		<%for(int i=0; i<list.size(); i++){
      				ScheduleDTOImpl dto = (ScheduleDTOImpl)list.get(i);%>
      				{
      					title : "<%=dto.getSubject()%>",
      					start : "<%=dto.getStartDate()%>",
      					end : "<%=dto.getEndDate()%>"
      				},
      				<%
      				}
      				%>
        			{
        				title : 'default',
        				start : "2020-01-01",
        				end : "2020-01-01"
        			}
      		],
      		select: function(info) {
          	//alert('selected ' + info.startStr + ' to ' + info.endStr );
      			fetchDocumentsBetweenDates("test4@gmail.com",info.startStr,info.endStr);
        	}
    	});
    calendar.render();
  });

</script>
</head>
<body>
  
  <div id='calendar' style="position : relative;">
  </div>
  <form name="frmPopup" method="post">
	<input type="hidden" name="arg1">
	<input type="hidden" name="arg2">
	<input type="hidden" name="arg3">
	</form> 
</body>

</html>