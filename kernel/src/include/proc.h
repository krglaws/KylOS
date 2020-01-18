
#ifndef _PROC_H_
#define _PROC_H_

// ==================
// Process attributes
// ==================

// --------------
// Process States

enum proc_state {
	RUNNING,
	READY,
	WAITING
};

// ----------------
// Process Priority

enum proc_priority {
	PRIORITY_1,
	PRIORITY_2,
	PRIORITY_3,
	PRIORITY_4,
	PRIORITY_5
};


// =================
// Kernel Structures
// =================

// --------------------------------------
// Process struct
// - Describes a currently executing
// - process, containing information such
// - as process ID, name, location, etc.

struct process {
	const unsigned int id;
	const char* name;
	enum proc_state state;
	enum proc_priority priority;

	const void *text_start;
	const void *data_start;

	const void *heap_start;
	void *heap_ptr;
	
	void *stack_ptr;
	const void *stack_start;
};

// -------------------------------
// Process Tree Node struct
// - Node within the process tree.
// - Contains a pointer to a
// - process, its parent, and
// - its children.

struct proc_tree_node {
	struct process* proc;

	struct proc_tree_node* parent;
	struct proc_tree_node* children;

	struct proc_tree_node* prev_sib;
	struct proc_tree_node* next_sib;
};

// ----------------------------------
// Process Tree struct
// - Contains a tree of all currently
// - all currently running processes,
// - as well as tree metadata.

struct proc_tree {
	unsigned int num_procs;
	struct proc_tree_node* root;
};


// =====================
// Function Declarations
// =====================

// --------------
// kill a process

unsigned int kill_proc(const unsigned int pid);

// ----------------
// signal a process

unsigned int sign_proc(const unsigned int pid, const unsigned int signal);

#endif

