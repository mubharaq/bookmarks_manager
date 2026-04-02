// this was created because [Mutation.run] rethrow errors,
// but we already handled the error from the repository
// we do not want it to bubble up like an uncaught exception
// ignore_for_file: avoid_catches_without_on_clauses

extension MutationRunX on Future<void> {
  Future<void> suppress() async {
    try {
      await this;
    } catch (_) {}
  }
}
