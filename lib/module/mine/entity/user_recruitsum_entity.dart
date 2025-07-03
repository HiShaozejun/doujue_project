class UserRecruitSumEntity {
/*
{
  "jobs_total": 405,
  "claim_jobs_total": 48
}
*/

  int? jobsTotal;
  int? claimJobsTotal;

  UserRecruitSumEntity({
    this.jobsTotal,
    this.claimJobsTotal,
  });

  UserRecruitSumEntity.fromJson(Map<String, dynamic> json) {
    jobsTotal = json['jobs_total']?.toInt();
    claimJobsTotal = json['claim_jobs_total']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['jobs_total'] = jobsTotal;
    data['claim_jobs_total'] = claimJobsTotal;
    return data;
  }
}
