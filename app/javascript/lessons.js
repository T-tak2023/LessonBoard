document.addEventListener('turbo:load', function() {
  console.log('Turbo load event fired');
  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
      headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,timeGridDay'
    },
    locale: 'ja',
    timeZone: 'Asia/Tokyo',
    businessHours: true,
    eventDisplay: 'block',
    eventTimeFormat: {
      hour: 'numeric',
      minute: '2-digit',
      meridiem: false
    },
    selectable: true,
    select: function(info) {
      // フォームを表示
      document.getElementById('eventModal').style.display = 'block';
      // 選択された時間範囲をフォームに設定
      document.getElementById('start_time').value = new Date(info.start).toISOString().slice(0, 16);
      document.getElementById('end_time').value = new Date(info.end).toISOString().slice(0, 16);
    },
    events: function(fetchInfo, successCallback, failureCallback) {
      fetch('/lessons.json')
        .then(response => response.json())
        .then(data => {
          console.log('Fetched lessons:', data); // ここで取得したデータをログに出力
          successCallback(data.map(lesson => ({
            id: lesson.id,
            title: lesson.student_name || 'No name',
            start: lesson.start_time,
            end: lesson.end_time,
            allDay: false,
            extendedProps: {
              status: lesson.status,
              instructor_id: lesson.instructor_id,
              student_id: lesson.student_id,
              instructor_name: lesson.instructor_name,
              student_name: lesson.student_name
            }
          })));
        })
        .catch(error => {
          console.error('Error fetching events:', error);
          failureCallback(error);
        });
    },
    editable: true,
    eventClick: function(info) {
      console.log('Event clicked:', info.event.extendedProps);

      // イベントの詳細をモーダルに設定
      document.getElementById('eventTitle').textContent = info.event.title;
      document.getElementById('eventStartTime').textContent = new Date(info.event.start).toLocaleString();
      document.getElementById('eventEndTime').textContent = new Date(info.event.end).toLocaleString();
      document.getElementById('eventStatus').textContent = info.event.extendedProps.status;
      document.getElementById('eventInstructor').textContent = info.event.extendedProps.instructor_name;
      document.getElementById('eventStudent').textContent = info.event.extendedProps.student_name;

      // モーダルを表示
      document.getElementById('eventDetailModal').style.display = 'block';
    },
    eventDrop: function(info) {
      console.log('Event dropped:', info.event);
    }
  });

  calendar.render();

  // フォーム送信時の処理
  document.getElementById('eventForm').addEventListener('submit', function(event) {
    event.preventDefault();
    var formData = new FormData(event.target);
    var data = {
      start_time: formData.get('start_time'),
      end_time: formData.get('end_time'),
      student_id: formData.get('student_id'),
      status: formData.get('status'),
      instructor_id: formData.get('instructor_id')
    };
    fetch('/lessons', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ lesson: data })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        calendar.addEvent({
          id: data.lesson.id,
          title: data.lesson.student_name,
          start: data.lesson.start_time,
          end: data.lesson.end_time,
          extendedProps: {
            status: data.lesson.status,
            start_time: data.lesson.start_time,
            end_time: data.lesson.end_time,
            instructor_id: data.lesson.instructor_id,
            student_id: data.lesson.student_id
          }
        });
        alert('Event added successfully!');
      } else {
        alert('Failed to add event: ' + data.errors.join(', '));
      }
    })
    .catch(error => console.error('Error:', error));

    // フォームを非表示にする
    document.getElementById('eventModal').style.display = 'none';
  });

  // モーダルのクローズボタン処理
  document.getElementById('closeDetailBtn').addEventListener('click', function() {
    document.getElementById('eventDetailModal').style.display = 'none';
  });

  // キャンセルボタンの処理
  document.getElementById('cancelBtn').addEventListener('click', function() {
    document.getElementById('eventModal').style.display = 'none';
  });
});
