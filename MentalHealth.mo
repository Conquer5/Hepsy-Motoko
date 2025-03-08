import Time "mo:base/Time";
import Text "mo:base/Text";
import List "mo:base/List";
import Option "mo:base/Option";
import Int "mo:base/Int";

actor Hepsy {
  // Fungsi helper untuk menambahkan elemen di awal list
  private func cons<T>(x : T, xs : List.List<T>) : List.List<T> {
    return List.append(List.fromArray([x]), xs);
  };

  // ================== DEFINISI TIPE ====================
  public type Mood = {
    #Happy;
    #Excited;
    #Relaxed;
    #Sad;
    #Stressed;
    #Anxious;
    #Angry;
    #Neutral;
    #Calm;
    #Tired;
  };

  public type User = {
    username : Text;
    fullName : Text;
  };

  public type AnonymousPost = {
    id : Nat;
    author : Text;
    content : Text;
    timestamp : Int;
  };
  // Definisikan tipe pilihan untuk ChatBot
  public type ChatOption = {
    #Stress;
    #Sad;
    #Happy;
    #Excited;
    #Default;
  };

  public type Consultation = {
    user: User;
    psychologist: Text;
    date: Int;
  };

  public type CommunityEvent = {
    id : Nat;
    name : Text;
    date : Int;
    description : Text;
  };

  // Data konsultasi psikologi
  stable var consultations : List.List<Consultation> = List.nil();

  // ================== VARIABEL STABIL ====================
  stable var userMoods : List.List<(User, List.List<(Mood, Int)>)> = List.nil();
  stable var adminUsers : List.List<Text> = List.fromArray(["admin1"]);
  stable var anonymousPosts : List.List<AnonymousPost> = List.nil();
  stable var postCounter : Nat = 0;
  stable var communityEvents : List.List<CommunityEvent> = List.nil();
  stable var eventCounter : Nat = 0;
  stable var podcasts : List.List<(Text, Text, Nat)> = List.nil();
  stable var articles : List.List<(Text, List.List<Mood>)> = List.nil();

  // ================== FUNGSI PEMBANTU ====================
  private func isAdmin(username : Text) : Bool {
    return List.some<Text>(adminUsers, func(a) = a == username);
  };

  // ================== FUNGSI SUASANA HATI ======================
  public func MoodStatus(username : Text, fullName : Text, mood : Mood) : async Text {
    let timestamp : Int = Time.now();
    let user : User = { username = username; fullName = fullName };

    let existing : ?(User, List.List<(Mood, Int)>) = List.find<(User, List.List<(Mood, Int)>)>(
      userMoods,
      func(entry : (User, List.List<(Mood, Int)>) ) : Bool {
        entry.0.username == username
      }
    );

    switch (existing) {
      case (?entry) {
        let (userData, moods) : (User, List.List<(Mood, Int)>) = entry;
        let updatedMoods : List.List<(Mood, Int)> = cons((mood, timestamp), moods);
        userMoods := List.map<(User, List.List<(Mood, Int)>), (User, List.List<(Mood, Int)>)>(
          userMoods,
          func(e : (User, List.List<(Mood, Int)>) ) : (User, List.List<(Mood, Int)>) {
            if (e.0.username == username) { (userData, updatedMoods) } else { e }
          }
        );
      };
      case null {
        let newEntry : (User, List.List<(Mood, Int)>) = (user, cons((mood, timestamp), List.nil<(Mood, Int)>()));
        userMoods := cons(newEntry, userMoods);
      };
    };
    return "Berhasil mencatat suasana hati " # fullName # "!";
  };

  public func MoodHistory(username : Text) : async ?(Text, List.List<(Mood, Int)>) {
    let userEntry : ?(User, List.List<(Mood, Int)>) = List.find<(User, List.List<(Mood, Int)>)>(
      userMoods,
      func(entry : (User, List.List<(Mood, Int)>) ) : Bool {
        entry.0.username == username
      }
    );

    switch (userEntry) {
      case (?entry) {
        let fullName : Text = entry.0.fullName;
        let moods : List.List<(Mood, Int)> = entry.1;
        return ?(fullName, moods);
      };
      case null { return null };
    };
  };

  // ================== FUNGSI ADMIN =====================
  public func addAdmin(requester : Text, newAdmin : Text) : async Text {
    if (not isAdmin(requester)) {
      return "Hanya admin yang dapat menambahkan admin baru!";
    };

    if (List.some<Text>(adminUsers, func(a) = a == newAdmin)) {
      return "Pengguna ini sudah menjadi admin!";
    };

    adminUsers := cons(newAdmin, adminUsers);
    return "Admin " # newAdmin # " berhasil ditambahkan!";
  };

  public func removeAdmin(requester : Text, adminToRemove : Text) : async Text {
    if (not isAdmin(requester)) {
      return "Hanya admin yang dapat menghapus admin!";
    };

    if (adminToRemove == requester) {
      return "Anda tidak bisa menghapus diri sendiri sebagai admin!";
    };

    let newAdminList : List.List<Text> = List.filter<Text>(
      adminUsers,
      func(a) = a != adminToRemove
    );

    if (List.size(newAdminList) == List.size(adminUsers)) {
      return "Admin tidak ditemukan!";
    };

    adminUsers := newAdminList;
    return "Admin " # adminToRemove # " berhasil dihapus!";
  };

  // ================== POST ANONIM =====================
  public func postAnonymous(username : Text, content : Text) : async Text {
    let timestamp : Int = Time.now();
    let newPost : AnonymousPost = {
      id = postCounter;
      author = username;
      content = content;
      timestamp = timestamp;
    };

    postCounter += 1;
    anonymousPosts := cons(newPost, anonymousPosts);
    return "Curhat berhasil dikirim secara anonim.";
  };

  public func getUserAnonymousPosts(username : Text) : async List.List<AnonymousPost> {
    return List.filter<AnonymousPost>(
      anonymousPosts,
      func(post : AnonymousPost) : Bool { post.author == username }
    );
  };

  public func getAnonymousPosts(username : Text) : async ?List.List<AnonymousPost> {
    if (not isAdmin(username)) {
      return null;
    };
    return ?anonymousPosts;
  };

  // ================== ACARA KOMUNITAS ====================
  public func addCommunityEvent(admin : Text, name : Text, date : Int, description : Text) : async Text {
    if (not isAdmin(admin)) {
      return "Hanya admin yang dapat menambahkan event!";
    };

    let newEvent : CommunityEvent = {
      id = eventCounter;
      name = name;
      date = date;
      description = description;
    };

    eventCounter += 1;
    communityEvents := cons(newEvent, communityEvents);
    return "Event komunitas berhasil ditambahkan.";
  };

  public func getCommunityEvents() : async List.List<CommunityEvent> {
    return communityEvents;
  };

  // ================== FITUR KONTEN ====================
  public func addStory(title : Text, speaker : Text, duration : Nat) : async Text {
    let newPodcast : (Text, Text, Nat) = (title, speaker, duration);
    podcasts := cons(newPodcast, podcasts);
    return "Story berhasil ditambahkan!";
  };

  public func Story() : async List.List<(Text, Text, Nat)> {
    return podcasts;
  };

  public func addArticle(title : Text, relevantMoods : List.List<Mood>) : async Text {
    let newArticle : (Text, List.List<Mood>) = (title, relevantMoods);
    articles := cons(newArticle, articles);
    return "Artikel berhasil ditambahkan!";
  };

  public func RecommendedArticles(username : Text) : async List.List<Text> {
    let userEntry : ?(User, List.List<(Mood, Int)>) = List.find<(User, List.List<(Mood, Int)>)>(
      userMoods,
      func(entry : (User, List.List<(Mood, Int)>) ) : Bool { entry.0.username == username }
    );

    switch (userEntry) {
      case (?entry) {
        let moods : List.List<Mood> = List.map<(Mood, Int), Mood>(
          entry.1,
          func(e : (Mood, Int)) : Mood { e.0 }
        );

        let filteredArticles : List.List<(Text, List.List<Mood>)> = List.filter<(Text, List.List<Mood>)>(
          articles,
          func(article : (Text, List.List<Mood>) ) : Bool {
            let (_, relevantMoods) = article;
            List.some<Mood>(
              moods,
              func(mood : Mood) : Bool {
                List.some<Mood>(
                  relevantMoods,
                  func(relMood : Mood) : Bool { mood == relMood }
                )
              }
            )
          }
        );

        return List.map<(Text, List.List<Mood>), Text>(
          filteredArticles,
          func(a : (Text, List.List<Mood>) ) : Text { a.0 }
        );
      };
      case null { return List.nil<Text>() };
    };
  };

  // ================== FUNGSI UTILITAS ===================
  public func DailyReminder(username : Text) : async Text {
    let userEntry : ?(User, List.List<(Mood, Int)>) = List.find<(User, List.List<(Mood, Int)>)>(
      userMoods,
      func(entry : (User, List.List<(Mood, Int)>) ) : Bool { entry.0.username == username }
    );

    switch (userEntry) {
      case (?entry) {
        let fullName : Text = entry.0.fullName;
        let moods : List.List<(Mood, Int)> = entry.1;

        // Memecah tuple hasil List.pop
        let (maybeMood, _) = List.pop(moods);
        let lastMood : ?(Mood, Int) = maybeMood;

        let message : Text = switch (lastMood) {
          case (? (#Happy, _)) { "🌟 Suasana hati yang baik, " # fullName # "! Terus sebarkan kebahagiaan hari ini!" };
          case (? (#Excited, _)) { "🚀 Mari buat hari ini luar biasa, " # fullName # "! Pertahankan semangat itu!" };
          case (? (#Relaxed, _)) { "🌿 Santai dan nikmati momen ini, " # fullName # ". Ketenteramanmu sangat berharga!" };
          case (? (#Sad, _)) { "💙 Tidak apa-apa merasa sedih kadang-kadang, " # fullName # ". Ingat, besok adalah hari baru!" };
          case (? (#Stressed, _)) { "😌 Tarik napas... Hembuskan napas... Kamu bisa, " # fullName # "!" };
          case (? (#Anxious, _)) { "💜 Kamu tidak sendirian, " # fullName # ". Cobalah bernapas dalam-dalam, dan hadapi satu langkah pada satu waktu." };
          case (? (#Angry, _)) { "🔥 Luangkan waktu untuk menenangkan diri, " # fullName # ". Mari salurkan energi itu ke sesuatu yang positif!" };
          case (? (#Neutral, _)) { "✨ Hai " # fullName # ", mari tambahkan sedikit kegembiraan ke harimu!" };
          case (? (#Calm, _)) { "🕊️ Terus nikmati ketenanganmu hari ini, " # fullName # "!" };
          case (? (#Tired, _)) { "😴 Hai " # fullName # ", jangan lupa untuk istirahat. Kamu pantas mendapatkannya!" };
          case null { "🌞 Selamat pagi, " # fullName # "! Mari buat hari ini menjadi yang terbaik!" };
        };

        return message;
      };
      case null { return "Pengguna tidak ditemukan!" };
    };
  };

  // FUNGSI UNTUK MENJADWALKAN KONSULTASI
  public func ScheduleConsultation(username: Text, fullName: Text, psychologist: Text, date: Int) : async Text {
    let user : User = { username = username; fullName = fullName };
    let newConsultation : Consultation = { user = user; psychologist = psychologist; date = date };

    consultations := cons(newConsultation, consultations);
    
    return "Konsultasi berhasil dijadwalkan dengan " # psychologist # " pada " # Int.toText(date);
  };

  // FUNGSI UNTUK MELIHAT JADWAL KONSULTASI
  public func ViewConsultation(username: Text) : async ?Consultation {
    List.find<Consultation>(
      consultations, 
      func(c : Consultation) : Bool { c.user.username == username }
    )
  };

  // FUNGSI UNTUK MEMBATALKAN KONSULTASI
  public func CancelConsultation(username: Text) : async Text {
    let newList = List.filter<Consultation>(
      consultations, 
      func(c : Consultation) : Bool { c.user.username != username }
    );
    let isCancelled = List.size(consultations) > List.size(newList);
    consultations := newList;

    if (isCancelled) {
      return "🚫 Konsultasi untuk " # username # " telah dibatalkan.";
    } else {
      return "❌ Tidak ada konsultasi yang ditemukan untuk " # username;
    }
  };

  // Fungsi ChatBot berbasis pilihan
  public func ChatBotChoice(option : ChatOption) : async Text {
    switch (option) {
      case (#Stress) {
        "Tidak apa-apa merasa stres. Cobalah latihan pernapasan dalam!";
      };
      case (#Sad) {
        "Kamu tidak sendirian. Berbicara dengan seseorang mungkin membantu.";
      };
      case (#Happy) {
        "Senang mendengarnya! Semoga harimu menyenankan!";
      };
      case (#Excited) {
        "Luar biasa! Teruskan semangatmu!";
      };
      case (#Default) {
        "Saya di sini untukmu! Tetap kuat!";
      };
    }
  };
};
