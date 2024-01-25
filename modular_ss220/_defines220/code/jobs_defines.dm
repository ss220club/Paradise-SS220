#define NOVICE_JOB_MINUTES 120
#define NOVICE_CADET_JOB_MINUTES 300

//JOBCAT_"отдел"_LAST - нужен для корректного вывода из БД, иначе чуда не будет.
// Он должен быть всегда как минимум на 1 больше последнего, по дефолту у ОФФов (1<<16)

// JOBCAT_ENGSEC
#define JOB_TRAINEE				(1<<15)
#define JOB_CADET				(1<<16)
#define JOBCAT_ENGSEC_LAST		(1<<17)

// JOBCAT_MEDSCI
#define JOB_INTERN				(1<<11)
#define JOB_STUDENT				(1<<12)
#define JOBCAT_MEDSCI_LAST		(1<<16)

// JOBCAT_SUPPORT
#define JOBCAT_SUPPORT_LAST		(1<<16)

// Если ОФФы добавят новую должность в отдел, то потребуется смещение
