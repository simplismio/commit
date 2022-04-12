class ContractModel {
  final String? key;
  final String? title;
  final String? ownerUserId;
  final List? participants;
  final List? commitments;

  ContractModel(
      {this.key,
      this.title,
      this.ownerUserId,
      this.participants,
      this.commitments});
}
