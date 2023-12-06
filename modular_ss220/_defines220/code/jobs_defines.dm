#define NOVICE_JOB_MINUTES 120
#define NOVICE_CADET_JOB_MINUTES 300

// Если ОФФы добавят новую должность в отдел, то потребуется смещение

// ====================================
//			JOBCAT_ENGSEC
#define JOB_TRAINEE				(1<<15)
#define JOB_CADET				(1<<16)

// ====================================
//			JOBCAT_MEDSCI
#define JOB_INTERN				(1<<11)
#define JOB_STUDENT				(1<<12)

// ====================================
//			JOBCAT_SUPPORT
// Начинаются с JOB_EXPLORER (1<<14),
// Смещаем, если ОФФы добавляют что-то еще

#define JOB_DONOR_TIER_1		(1<<15)
#define JOB_DONOR_TIER_2		(1<<16)
#define JOB_DONOR_TIER_3		(1<<17)
#define JOB_DONOR_TIER_4		(1<<18)
#define JOB_DONOR_TIER_5		(1<<19)
