document.addEventListener('turbo:load', function() {
  console.log('Turbo load event fired');

  function formatDateToLocal(date) {
    const offset = date.getTimezoneOffset();
    const localDate = new Date(date.getTime() - offset * 60000);
    return localDate.toISOString().slice(0, 16);
  }

  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
      headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,timeGridDay'
    },
    locale: 'ja',
    timeZone: 'local',
    businessHours: {
      startTime: '00:00',
      endTime: '24:00',
    },
    eventColor: '#56cc9d',
    eventDisplay: 'block',
    eventTimeFormat: {
      hour: 'numeric',
      minute: '2-digit',
      meridiem: false
    },
    navLinks: true,
    selectable: true,
    select: function(info) {
      var detailModal = document.getElementById('eventDetailModal');
      var editModal = document.getElementById('eventEditModal');

      // モーダルが表示されていない場合のみ、新規登録モーダルを表示
      if ((detailModal && detailModal.style.display === 'none') &&
          (editModal && editModal.style.display === 'none')) {
      // フォームを表示
        document.getElementById('eventModal').style.display = 'block';

        var startDate = info.start;
        var endDate = info.end;

        // 月表示の場合（時刻が未指定の場合）にデフォルトの時間を設定
        if (startDate.getHours() === 0 && endDate.getHours() === 0) {
          startDate.setHours(9, 0);
          endDate = new Date(startDate);
          endDate.setHours(10, 0);
        }

        // 選択された時間範囲をフォームに設定
        document.getElementById('start_time').value = formatDateToLocal(startDate);
        document.getElementById('end_time').value = formatDateToLocal(endDate);

        document.getElementById('start_time').focus();
      }
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

    eventClassNames: function(arg) {
      if (arg.event.extendedProps.status === '保留') {
        return ['calendar-event-pending'];
      } else if (arg.event.extendedProps.status === 'キャンセル') {
        return ['calendar-event-cancelled'];
      }
      return [];
    },

    eventClick: function(info) {
      console.log('Event clicked:', info.event.extendedProps);
      // モーダルが表示されていない場合のみ、詳細モーダルを表示
      var createModal = document.getElementById('eventModal');
      var editModal = document.getElementById('eventEditModal');

      if (createModal.style.display === 'none' && editModal.style.display === 'none'){
        currentEvent = info.event;

        document.getElementById('eventStartTime').textContent = info.event.start.toLocaleString('ja-JP', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit'
        });
        document.getElementById('eventEndTime').textContent = info.event.end.toLocaleString('ja-JP', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit'
        });
        document.getElementById('eventStatus').textContent = info.event.extendedProps.status;
        document.getElementById('eventInstructor').textContent = info.event.extendedProps.instructor_name;
        document.getElementById('eventStudent').textContent = info.event.extendedProps.student_name;

        var eventStatus = document.getElementById('eventStatus');
        eventStatus.classList.remove('modal-confirmed-status', 'modal-pending-status', 'modal-cancelled-status');

        if (info.event.extendedProps.status === '確定') {
            eventStatus.classList.add('modal-confirmed-status');
        } else if (info.event.extendedProps.status === '保留') {
            eventStatus.classList.add('modal-pending-status');
        } else if (info.event.extendedProps.status === 'キャンセル') {
            eventStatus.classList.add('modal-cancelled-status');
        }

        document.getElementById('eventDetailModal').style.display = 'block';
      }
    },
    editable: true,
    eventDrop: function(info) {
      console.log('Event dropped:', info.event);
    }
  });

  calendar.render();

  document.getElementById('editEventBtn').addEventListener('click', function() {
    console.log('Edit button clicked');
    if (currentEvent) {
      document.getElementById('edit_start_time').value = formatDateToLocal(currentEvent.start);
      document.getElementById('edit_end_time').value = formatDateToLocal(currentEvent.end);
      document.getElementById('edit_status').value = currentEvent.extendedProps.status;
      document.getElementById('edit_student_id').value = currentEvent.extendedProps.student_id;
      document.getElementById('edit_event_id').value = currentEvent.id;

      document.getElementById('eventDetailModal').style.display = 'none';
      document.getElementById('eventEditModal').style.display = 'block';
    }
  });

  document.getElementById('cancelEditBtn').addEventListener('click', function() {
    document.getElementById('eventEditModal').style.display = 'none';
  });

  document.getElementById('eventEditForm').addEventListener('submit', function(event) {
    event.preventDefault();

    var formData = new FormData(event.target);
    var data = {
      start_time: formData.get('start_time'),
      end_time: formData.get('end_time'),
      student_id: formData.get('student_id'),
      status: formData.get('status'),
      instructor_id: formData.get('instructor_id'),
      event_id: formData.get('event_id')
    };

    fetch('/lessons/' + data.event_id, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ lesson: data })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(responseData => {
      if (responseData.success) {
        // イベントをカレンダーに反映
        var event = calendar.getEventById(responseData.lesson.id);
        if (event) {
          event.setProp('title', responseData.lesson.student_name);
          event.setStart(responseData.lesson.start_time);
          event.setEnd(responseData.lesson.end_time);
          event.setExtendedProp('status', responseData.lesson.status);
          event.setExtendedProp('student_id', responseData.lesson.student_id);
        }

        // モーダルを非表示にする
        document.getElementById('eventEditModal').style.display = 'none';
        alert('Event updated successfully!');
      } else {
        alert('Failed to update event: ' + responseData.errors.join(', '));
      }
    })
    .catch(error => {
      console.error('Error:', error);
      alert('Failed to update event. Please try again.');
    });
  });

  document.getElementById('deleteEventBtn').addEventListener('click', function() {
    console.log('delete button clicked');
    if (confirm('本当に削除しますか？')) {
      if (currentEvent) {
        fetch('/lessons/' + currentEvent.id, {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
        })
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();
        })
        .then(responseData => {
          if (responseData.success) {
            // イベントをカレンダーから削除
            var event = calendar.getEventById(currentEvent.id);
            if (event) {
              event.remove();
            }

            // モーダルを非表示にする
            document.getElementById('eventDetailModal').style.display = 'none';
            alert('削除が完了しました');
          } else {
            alert('削除に失敗しました' + responseData.errors.join(', '));
          }
        })
        .catch(error => {
          console.error('Error:', error);
          alert('Failed to delete event. Please try again.');
        });
      }
    } else {
      // ユーザーがキャンセルした場合
      console.log('Event deletion canceled');
    }
  });

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
      console.log(data);

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
            student_id: data.lesson.student_id,
            instructor_name: data.lesson.instructor_name,
            student_name: data.lesson.student_name
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
