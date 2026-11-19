sealed class Countdown {
  const Countdown();

  factory Countdown.fromDateTime(DateTime target, {DateTime? now}) {
    final current = now ?? DateTime.now();
    if (target.isAfter(current)) {
      return Upcoming(target.difference(current));
    }
    final elapsed = current.difference(target);
    if (elapsed < const Duration(hours: 1)) {
      return Started(elapsed);
    }
    return const Ended();
  }
}

final class Upcoming extends Countdown {
  const Upcoming(this.remaining);
  final Duration remaining;
}

final class Started extends Countdown {
  const Started(this.elapsed);
  final Duration elapsed;
}

final class Ended extends Countdown {
  const Ended();
}
