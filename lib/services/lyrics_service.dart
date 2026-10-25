class LyricsService {
  static String generate({required String topic, String style = "underground trap"}) {
    final clean = topic.trim().isEmpty ? "улица" : topic.trim();
    return """
[Intro]
$clean... пускам баса
Тъмно е навън, сърцето ми е глас

[Verse 1]
Ставам в 6, железен труд ме чака
$clean в главата, няма място за оплакване
България ме стиска, но аз не спирам
Римата е оръжие, думите ми стрелят

[Chorus]
$clean, $clean, това е моят път
Неон зелено в тъмнината, не ме спира никой
Четвъртия качак, подземният звук
$clean в римите, басът удря здраво

[Verse 2]
Системата е глупава, аз плащам данък
Но в студиото съм цар, не роб на никой
$clean ме държи жив в тези нощи
Гласът ми е огън, думите са ножове

[Outro]
$clean... fade out
MDP 420
""".trim();
  }
}
