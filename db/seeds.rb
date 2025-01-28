guest_instructor = Instructor.find_or_create_by!(email: 'guest_instructor@example.com') do |instructor|
  instructor.password = SecureRandom.urlsafe_base64
  instructor.instructor_name = 'ゲスト 講師'
end

Student.skip_callback(:create, :before, :set_enrollment_date)

guest_student = Student.find_or_create_by!(email: 'guest_student@example.com') do |student|
  student.password = SecureRandom.urlsafe_base64
  student.student_name = 'ゲスト 生徒'
  student.instructor = guest_instructor
  student.course = '作詞作曲'
  student.enrollment_date = 1.year.ago.to_date
end

sample_students = [
  { email: 'john@example.com', name: 'ジョン レノン', course: 'アコースティックギター' },
  { email: 'paul@example.com', name: 'ポール マッカートニー', course: 'エレキベース' },
  { email: 'george@example.com', name: 'ジョージ ハリスン', course: 'エレキギター' },
  { email: 'ringo@example.com', name: 'リンゴ スター', course: 'ドラム' }
]

sample_students.each do |student_data|
  Student.find_or_create_by!(email: student_data[:email]) do |student|
    student.student_name = student_data[:name]
    student.password = 'password'
    student.instructor = guest_instructor
    student.course = student_data[:course]
    student.enrollment_date = Date.new(1963, 3, 22)
  end
end

Student.set_callback(:create, :before, :set_enrollment_date)

sample_emails = [
  'guest_student@example.com',
  'john@example.com',
  'paul@example.com',
  'george@example.com',
  'ringo@example.com'
]

students = Student.where(email: sample_emails)
guest_instructor = Instructor.find_by(email: 'guest_instructor@example.com')

LOCATIONS = ['スタジオA', 'スタジオB', 'スタジオC', 'オンライン'].freeze

current_time = Time.current

students.each do |student|
  used_dates = Set.new

  total_lessons = rand(0..6)
  past_count = total_lessons / 2
  future_count = total_lessons - past_count

  past_count.times do |i|
    begin
      start_time = (current_time - rand(1..30).days).change(
        hour: rand(10..18),
        min: [0, 30].sample
      )
    end while used_dates.include?(start_time.to_date)

    used_dates.add(start_time.to_date)

    status = rand(100) < 80 ? "確定" : "キャンセル"

    Lesson.create!(
      start_time: start_time,
      end_time: start_time + 1.hour,
      instructor: guest_instructor,
      student: student,
      status: status,
      location: LOCATIONS.sample,
      created_at: start_time - rand(1..7).days,
      updated_at: start_time - rand(1..7).days
    )
  end

  future_count.times do |i|
    begin
      start_time = (current_time + rand(1..30).days).change(
        hour: rand(10..18),
        min: [0, 30].sample
      )
    end while used_dates.include?(start_time.to_date)

    used_dates.add(start_time.to_date)

    status = case rand(100)
            when 0..59 then "確定"
            when 60..89 then "保留"
            else "キャンセル"
            end

    Lesson.create!(
      start_time: start_time,
      end_time: start_time + 1.hour,
      instructor: guest_instructor,
      student: student,
      status: status,
      location: LOCATIONS.sample,
      created_at: current_time - rand(1..7).days,
      updated_at: current_time - rand(1..7).days
    )
  end
end

LESSON_CONTENTS = {
  'アコースティックギター' => [
    '基本的なコードストロークの練習。A、D、Gコードのスムーズな切り替えを重点的に行いました。',
    'アルペジオの基礎練習。指の独立した動きの習得に焦点を当てました。',
    'カポタストを使用した演奏方法の練習。キー移動の理解を深めました。'
  ],
  'エレキベース' => [
    'スラップ奏法の基礎練習。親指と人差し指の使い方を確認しました。',
    'ウォーキングベースの練習。ジャズの基本進行を使用。',
    '16ビートのグルーヴ作り。メトロノームを使用したタイミング練習。'
  ],
  'エレキギター' => [
    'ペンタトニックスケールの練習。ポジション移動を中心に。',
    'ディストーション時のミュート奏法について練習。',
    'タッピング奏法の基礎練習。右手のフォームを重点的に。'
  ],
  'ドラム' => [
    '基本的な8ビートパターンの練習。ハイハットワークを中心に。',
    'ゴーストノートを使用したグルーヴ作り。',
    'フィルインの練習。8小節を使った展開方法。'
  ],
  '作詞作曲' => [
    'コード進行の基礎復習。王道進行を使った作曲演習。',
    'メロディーとコードの関係性について。スケールの選び方。',
    'サビの盛り上げ方について。歌詞とメロディーの関係。'
  ]
}.freeze

INSTRUCTOR_MEMOS = [
  '左手の小指の使い方に癖あり。要フォーム修正。次回フォローする。',
  'テンポキープが不安定。基礎練習のメニューを組み直す必要あり。',
  'コード進行の理解度低め。次回は基礎に立ち返って説明し直す。',
  '姿勢が猫背気味。長時間練習に支障が出る可能性あり→要注意。',
  '楽器のメンテナンス状態が悪い。手入れの方法を詳しく説明する必要あり。'
].freeze

STUDENT_MEMOS = [
  '家での練習方法について理解できました。毎日30分は練習するようにします。',
  'テンポが速くなると混乱してしまうので、ゆっくり練習を重ねます。',
  '次回までにYouTube教材を見て予習しておきます。'
].freeze

YOUTUBE_MATERIALS = [
  'https://www.youtube.com/watch?v=N8eo4urtFfc',
  'https://www.youtube.com/watch?v=Tb83rbm0IVI',
  'https://youtu.be/APJAQoSCwuA?feature=shared',
  ''
].freeze

past_confirmed_lessons = Lesson.where('start_time < ? AND status = ?', Time.current, '確定')

past_confirmed_lessons.each do |lesson|
  course_contents = LESSON_CONTENTS[lesson.student.course] || LESSON_CONTENTS['作詞作曲']

  LessonNote.create!(
    instructor: lesson.instructor,
    student: lesson.student,
    content: course_contents.sample,
    instructor_memo: INSTRUCTOR_MEMOS.sample,
    student_memo: STUDENT_MEMOS.sample,
    video_material: YOUTUBE_MATERIALS.sample,
    start_time: lesson.start_time,
    end_time: lesson.end_time,
    location: lesson.location,
    created_at: lesson.end_time + rand(1..120).minutes,
    updated_at: lesson.end_time + rand(1..120).minutes
  )
end

puts "サンプルデータを作成しました！"
