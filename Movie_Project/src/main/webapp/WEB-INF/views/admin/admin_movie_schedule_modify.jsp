<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상영 일정 등록</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources//js/jquery-3.7.1.js"></script>
<script type="text/javascript">

	// 지점명 불러오기
	$(function() {
		$.ajax({
			type: "GET",
			url: "getTheater",
			success: function(result) {
				for(let theater of result) {
				$("#theater_id").append("<option value='" + theater.theater_id + "'>" + theater.theater_name + "</option>");
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				alert("지점명 로딩 오류입니다.");
			}
			
		});
	});
	
	// 상영관 불러오기
	$(function() {
		$("#theater_id").blur(function() {
			let theater_id = $("#theater_id").val();
			$.ajax({
				type: "GET",
				url: "getRoom",
				data: {
					theater_id : theater_id
				},
				success: function(result) {
					$("#room_id").empty();
					$("#room_id").append("<option value=''>상영관 선택</option>");
					for(let room of result) {
						$("#room_id").append("<option value='" + room.room_id + "'>" + room.room_name + "</option>");
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					alert("상영관 로딩 오류입니다.");
				}
				
			});
		});
	});
	
	// 상영중인 영화 불러오기
	$(function() {
		$.ajax({
			type: "GET",
			url: "nowPlaying",
			success: function(result) {
				for(let movie of result) {
				$("#movie_id").append("<option value='" + movie.movie_id + "'>" + movie.movie_title + "</option>");
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				alert("상영중인 영화 로딩 오류입니다.");
			}
			
		});
	});
	
	// 선택 가능한 날짜 불러오기
	$(function() {
		$("#movie_id").blur(function() {
			let movie_id = $("#movie_id").val();
			$.ajax({
				type: "GET",
				url: "getMovieInfo",
				data: {
					movie_id : movie_id
				},
				success: function(result) {
					if(movie_id != '') {						
						let release_date = new Date(result.movie_release_date + 86400000); // 밀리초단위를 날짜로 변환
						let f_release_date = release_date.toISOString().split('T')[0]; // 날짜의 형태를 0000-00-00으로 변환
						let close_date = new Date(result.movie_close_date + 86400000); // 밀리초단위를 날짜로 변환
						let f_close_date = close_date.toISOString().split('T')[0]; // 날짜의 형태를 0000-00-00으로 변환
						
						$("#date").html("<input type='date' min='" + f_release_date + "' max='" + f_close_date + "' id='play_date' name='play_date'>");
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					alert("상영관 로딩 오류입니다.");
				}
			});
		});
	});
	
	// 영화 종료 시간 자동으로 계산
	$(function() {
		$("#play_start_time").blur(function() {
			let movie_id = $("#movie_id").val();
			let start_time = $("#play_start_time").val().split(":")[0];
// 			console.log(start_time); // 09
			
			$.ajax({
				type: "GET",
				url: "getMovieInfo",
				data: {
					movie_id : movie_id
				},
				success: function(result) {
					if(start_time == '') {
						$("#play_end_time").val('');
					} else {
						let end_time = (start_time * 60) + parseInt(result.movie_runtime)
						
						let hours = Math.floor(end_time / 60); // 시간 계산
						let minutes = end_time % 60; // 분 계산
						
						// 시간과 분이 한 자리 수인 경우 0으로 채우기
						let formatted_hours = hours < 10 ? "0" + hours : hours;
						let formatted_minutes = minutes < 10 ? "0" + minutes : minutes;
						
						let formatted_end_time = formatted_hours + ":" + formatted_minutes; // "00:00" 형식으로 변환된 종료 시간
						
						$("#play_end_time").val(formatted_end_time);						
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					alert("종료 시간 출력 오류입니다.");
				}
			});
		});
	});

	// 선행되어야 할 선택값이 필요한 경우 다음 선택을 하지 못하도록 막음
	$(function() {
		$("#room_id").click(function() {
			if($("#theater_id").val() == '') {
				alert("지점을 선택해주세요");
				$("#theater_id").focus();
			}
		});
		$("#date").click(function() {
			if($("#movie_id").val() == '') {
				alert("영화를 선택해주세요");
				$("#movie_id").focus();
			}
		});
		$("#play_start_time").click(function() {
			if($("#play_date").val() == '') {
				alert("날짜를 선택해주세요");
				$("#play_date").focus();
			} else if($("#movie_id").val() == '') {
				alert("영화를 선택해주세요");
				$("#movie_id").focus();
			}
		});
	});
	
	
	// 등록하기
	$(function() {
		$("#registForm").submit(function() {
			if($("#theater_id").val() == '') {
				alert("지점을 선택해주세요");
				$("#theater_id").focus();
				return false;
			} else if($("#room_id").val() == '') {
				alert("상영관을 선택해주세요");
				$("#room_id").focus();
				return false;
			} else if($("#movie_id").val() == '') {
				alert("영화를 선택해주세요");
				$("#movie_id").focus();
				return false;
			} else if($("#date>input").val() == '') {
				alert("상영날짜를 선택해주세요");
				$("#date>input").focus();
				return false;
			} else if($("#play_start_time").val() == '') {
				alert("상영시작시간을 선택해주세요");
				$("#play_start_time").focus();
				return false;
			} 
			
		});
	});
	
	// 삭제 버튼 클릭 시 이벤트 처리
	$(function() {
		$("#btnDelete").on("click", function() {
			if(confirm("상영 일정을 삭제하시겠습니까?")) {
				return true;
			} else {
				return false;
			}
		});
	});
	
	// 수정 버튼 클릭 시 이벤트 처리
	$(function() {
		$("#btnModify").on("click", function() {
// 			$("#modifyForm").html(
// 					"<table border='1'><tr><th>지점명</th><th>상영관명</th><th>영화제목</th><th>상영날짜</th><th>시작</th><th>종료</th><th>수정</th><th>삭제</th></tr>"
// 					+ "<c:forEach var='play' items='${playRegistList}'><input type='hidden' value='${play.play_id}' name='play_id'>"
// 					+ "<tr><td>${play.theater_name}</td><td>${play.room_name}</td><td>${play.movie_title}</td><td>${play.play_date}</td><td>${fn:substring(play.play_start_time, 0, 5)}</td><td>${fn:substring(play.play_end_time, 0, 5)}</td>"
// 					+ "<td><input type='button' value='수정' id='btnModify'></td>"
// 					+ "<td><input type='submit' value='삭제' id='btnDelete'></td></tr></c:forEach></table>"
// 			);
			$.ajax({ // 지점명 불러오기 ajax 재활용
				type: "GET",
				url: "getTheater",
				success: function(result) {
					
					// 기존 값 비우기
					$("#theater_name_mod").empty();
					
					// theater_name_mod 요소 선택
					let theaterNameMod = $("#theater_name_mod");
					
					// select 요소 생성
					let selectElement = $("<select></select>").attr("id", "theater_name").attr("name", "theater_id");
					
					// 지점 선택 기본 옵션 추가
					let defaultOption = $("<option></option>").attr("value", "").text("지점 선택");
					
					// select 요소 사이에 기본 옵션 끼워넣기 
  					selectElement.append(defaultOption);
					
					// 요청으로 받아온 데이터를 반복해 option 태그 추가
					for(let theater of result) {
						let option = $("<option></option>").attr("value", theater.theater_id).text(theater.theater_name);
	  					selectElement.append(option);
					}
					
					// select 요소를 theater_name_mod에 추가
					theaterNameMod.append(selectElement);
					
				},
				error: function(xhr, textStatus, errorThrown) {
					alert("지점명 로딩 오류입니다.");
				}
			}); // 지점명 불러오기 ajax 끝

		}); // 수정 버튼 click 이벤트 처리 끝
		
	}); // document.ready 끝
	
	
	
	
	// 수정 작업 중 지점 선택 완료 후 상영관 불러오기 재활용
	$(document).on("blur", "#theater_name", function() {
		// c.f. $("#theater_name") 요소가 동적으로 생성된 후에 blur 이벤트 핸들러를 등록해야 하므로
		//      $(function() {}) 코드를 $(document)로 수정
		
		let theater_name = $("#theater_name").val();
		$.ajax({
			type: "GET",
			url: "getRoom",
			data: {
				theater_id : theater_name // 변수명 수정 : theater_name 으로 변경
			},
			success: function(result) {

				// 기존 값 비우기
				$("#room_name_mod").empty();
			
				// room_name_mod 요소 선택
				let roomNameMod = $("#room_name_mod");

				// select 요소 생성
				let selectElement = $("<select></select>").attr("id", "room_name").attr("name", "room_id");
			
				// 상영관 선택 기본 옵션 추가
				let defaultOption = $("<option></option>").attr("value", "").text("상영관 선택");
			
				// select 요소 사이에 기본 옵션 끼워넣기 
				selectElement.append(defaultOption);
			
				// 요청으로 받아온 데이터를 반복해 option 태그 추가
				for(let room of result) {
					let option = $("<option></option>").attr("value", room.room_id).text(room.room_name);
  					selectElement.append(option);
				}
			
				// select 요소를 room_name_mod에 추가
				roomNameMod.append(selectElement);
			},
			error: function(xhr, textStatus, errorThrown) {
				alert("상영관 로딩 오류입니다.");
			}
		
		}); // 상영관 불러오기 ajax 끝
		
	}); // 지점 선택 blur 이벤트 처리 끝
	
	
	// 수정 작업 중 상영관 선택 완료 후 상영 중인 영화 불러오기 ajax 재활용
	$(document).on("blur", "#room_name", function() {
		
		$.ajax({
			type: "GET",
			url: "nowPlaying",
			success: function(result) {
				// 기존 값 비우기
				$("#movie_title_mod").empty();
			
				// movie_title_mod 요소 선택
				let movieTitleMod = $("#movie_title_mod");

				// select 요소 생성
				let selectElement = $("<select></select>").attr("id", "movie_title").attr("name", "movie_title");

			
				// 영화 선택 기본 옵션 추가
				let defaultOption = $("<option></option>").attr("value", "").text("영화 선택");
			
				// select 요소 사이에 기본 옵션 끼워넣기 
				selectElement.append(defaultOption);
			
			
				// 요청으로 받아온 데이터를 반복해 option 태그 추가
				for(let movie of result) {
					let option = $("<option></option>").attr("value", movie.movie_id).text(movie.movie_title);
  					selectElement.append(option);
				}
			
				// select 요소를 movie_title_mod에 추가
				movieTitleMod.append(selectElement);
			},
			error: function(xhr, textStatus, errorThrown) {
				alert("상영중인 영화 로딩 오류입니다.");
			}
		
		}); // 상영관 불러오기 ajax 끝
		
	}); // 지점 선택 blur 이벤트 처리 끝

	
	// 수정 작업 중 영화 선택 완료 후 선택 가능한 날짜 불러오기 ajax 재활용
	$(document).on("blur", "#movie_title", function() {
		
// 		alert("alertforcheck");
		
		let movie_title = $("#movie_title").val();

		$.ajax({
			type: "GET",
			url: "getMovieInfo",
			data: {
				movie_id : movie_title // 변수명 수정 : movie_title로 변경
			},
			success: function(result) {
				// 기존 값 비우기
				$("#play_date_mod").empty();

				if(movie_title != '') {						
					let release_date = new Date(result.movie_release_date + 86400000); // 밀리초단위를 날짜로 변환
					let f_release_date = release_date.toISOString().split('T')[0]; // 날짜의 형태를 0000-00-00으로 변환
					let close_date = new Date(result.movie_close_date + 86400000); // 밀리초단위를 날짜로 변환
					let f_close_date = close_date.toISOString().split('T')[0]; // 날짜의 형태를 0000-00-00으로 변환
		
					
					$("#play_date_mod").html("<input type='date' min='" + f_release_date + "' max='" + f_close_date + "' id='play_date2' name='play_date2'>");
					
					// 상영 시작 시간 셀렉트 박스 표시 
					$("#play_start_time_mod").html(
							"<select id='play_start_time2' name='play_start_time2'><option value=''>시작 시간 선택</option>"
							+ "<option value='09:00'>09:00</option><option value='10:00'>10:00</option><option value='11:00'>11:00</option>"
							+ "<option value='12:00'>12:00</option><option value='13:00'>13:00</option><option value='14:00'>14:00</option>"
							+ "<option value='15:00'>15:00</option><option value='16:00'>16:00</option><option value='17:00'>17:00</option>"
							+ "<option value='18:00'>18:00</option><option value='19:00'>19:00</option><option value='20:00'>20:00</option><option value='21:00'>21:00</option></select>"
					);
					
				}
			},
			error: function(xhr, textStatus, errorThrown) {
				alert("상영중인 영화 로딩 오류입니다.");
			}
		
		}); // 선택 가능한 날짜 정보 불러오기 ajax 끝

	}); // 영화 선택 blur 이벤트 처리 끝 
	
	
	
 	// 수정 작업 중 상영 시작 시간 선택 후 종료 시간 자동으로 계산
 	$(document).on("blur", "#play_start_time2", function() {
 		let movie_title = $("#movie_title").val();
		let start_time = $("#play_start_time2").val().split(":")[0];
// 		console.log(start_time);
		$.ajax({
			type: "GET",
			url: "getMovieInfo",
			data: {
				movie_id : movie_title
			},
			success: function(result) {
				if(start_time == '') { // 시작 시간 입력값이 없는 경우
					$("#play_end_time_mod").empty(); 
				} else {
					let end_time = (start_time * 60) + parseInt(result.movie_runtime); 
					// => 시작시간을 분 단위로 변환하고 러닝타임 덧셈
// 					console.log(end_time);
					
					let hours = Math.floor(end_time / 60); // 분 / 60으로 시간 단위 계산
					let minutes = end_time % 60; // 나머지로 분 계산
					
// 					console.log(hours + ", " + minutes);
					
// 					// 시간과 분이 한 자리 수인 경우 0으로 채우기
					let formatted_hours = hours < 10 ? "0" + hours : hours;
					let formatted_minutes = minutes < 10 ? "0" + minutes : minutes;
					
					let formatted_end_time = formatted_hours + ":" + formatted_minutes; // "00:00" 형식으로 변환된 종료 시간
					
					$("#play_end_time_mod").html(formatted_end_time);
					$("#btnModify").after("<input type='hidden' name='play_end_time2' value=" + formatted_end_time + ">");

				}
			},
			error: function(xhr, textStatus, errorThrown) {
				alert("종료 시간 출력 요청 실패!");
			}
			
		}); // 종료 시간 계산 용 정보 불러오기 ajax 끝
		
		// 옵션 모두 선택 후 수정 버튼 클릭 시
// 		$("#btnModify").on("click", function() {
// 			var formData = $("#modifyForm").serialize(); 
// 			$.ajax({ 
// 				type: "post",
// 				url: "modifyPlay",
// 				data: formData,
// 				success: function(result) {
// 					console.log("리턴값 : " + result);
// 				},
// 				error: function(xhr, textStatus, errorThrown) {
// 					console.log("상영 일정 수정 ajax 요청 실패!");
// 				}
		
// 			});
			
			
// 		});
 		
 	}); // 상영 시작 시간 선택 blur 이벤트 처리 끝 
	
	
	
	
</script>
</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top_admin.jsp"></jsp:include>
		</header>
	
		<jsp:include page="../inc/menu_nav_admin.jsp"></jsp:include>
		
		<section id="content">
			<h1 id="h01">상영 일정 등록</h1>
			<hr>
			<div id="admin_nav">
				<jsp:include page="admin_menubar.jsp"></jsp:include>
			</div>
			
			<div id="admin_main">
				<a href="adminMovieSchedule"><input type="button" value="상영일정조회"></a>
				<br><br>
				<form action="registPlay" method="post" id="registForm">
					<table border="1">
						<tr>
							<th width="170px">지점명</th>
							<th width="170px">상영관명</th>
							<th colspan="3">영화제목</th>
						</tr>
						<tr>
							<td>
								<select id="theater_id" name="theater_id">
									<option value="">지점 선택</option>
								</select>
							</td>
							<td>
								<select id="room_id" name="room_id">
									<option value="">상영관 선택</option>
								</select>
							</td>
							<td colspan="3">
								<select id="movie_id" name="movie_id">
									<option value="">영화 선택</option>
								</select>
							</td>
						</tr>
						<tr>
							<th width="170px">상영날짜</th>
							<th width="170px">상영시작시간</th>
							<th width="170px">상영종료시간</th>
							<th width="140px">등록</th>
							<th width="140px">초기화</th>
						</tr>
						<tr>
							<td id="date">
								<input type="date" id="play_date" name="play_date">
							</td>
							<td>
								<select id="play_start_time" name="play_start_time">
									<option value="">시작 시간 선택</option>
									<option value="09:00">09:00</option>
									<option value="10:00">10:00</option>
									<option value="11:00">11:00</option>
									<option value="12:00">12:00</option>
									<option value="13:00">13:00</option>
									<option value="14:00">14:00</option>
									<option value="15:00">15:00</option>
									<option value="16:00">16:00</option>
									<option value="17:00">17:00</option>
									<option value="18:00">18:00</option>
									<option value="19:00">19:00</option>
									<option value="20:00">20:00</option>
									<option value="21:00">21:00</option>
								</select>
							</td>
							<td>
								<input type="text" id="play_end_time" name="play_end_time" readonly>
							</td>
							<td>
								<input type="submit" value="등록" id="regist">
							</td>
							<td>
								<input type="reset" value="초기화">
							</td>
						</tr>
					</table>
				</form>
						
				<br>
				<form action="deletePlay" method="post" id="modifyForm">
					<table border="1">
						<tr>
							<th>지점명</th>
							<th>상영관명</th>
							<th>영화제목</th>
							<th>상영날짜</th>
							<th>시작</th>
							<th>종료</th>
							<th>수정</th>
							<th>삭제</th>
						</tr>
						<c:forEach var="play" items="${playRegistList}">
						<input type="hidden" value="${play.play_id}" name="play_id">
							<tr>
								<td id="theater_name_mod">${play.theater_name}</td>
								<td id="room_name_mod">${play.room_name}</td>
								<td id="movie_title_mod">${play.movie_title}</td>
								<td id="play_date_mod">${play.play_date}</td>
								<td id="play_start_time_mod">${fn:substring(play.play_start_time, 0, 5)}</td>
								<td id="play_end_time_mod">${fn:substring(play.play_end_time, 0, 5)}</td>
								<td>
									<input type="button" value="수정" id="btnModify">
								</td>
								<td>
									<input type="submit" value="삭제" id="btnDelete">
								</td>
							</tr>
						</c:forEach>
					</table>
				</form>	
			</div>
			<footer>
				<jsp:include page="../inc/bottom_admin.jsp"></jsp:include>
			</footer>
		</section>
	</div>
</body>
</html>