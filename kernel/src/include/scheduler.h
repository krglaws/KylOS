#include "proc.h"

#ifndef _SCHEDULER_H_
#define _SCHEDULER_H_

struct {
        struct queue_item* prev_item;
        struct process* proc;
        struct queue_item* next_item;
} queue_item;

struct {
	unsigned int num_procs;
	unsigned int quantum_ms;
	enum proc_priority priority;
	struct queue_item* next_up;
} proc_queue;

#endif
