generic 
    type element is private;
package dstack is
    -- This avoids comparation and asignation
    type stack is limited private;
    -- Exceptions
    empty_stack: exception;
    
    -- Stack specification
    procedure push(s: in out stack; e: in element);
    procedure pop(s: in out stack);
   procedure empty(s: in out stack);
   function is_empty(s: in stack) return Boolean;
   function top(s: in stack) return element;
private
    type node;
    type pnode is access node;
    type node is record
        e: element;
        next: pnode;
    end record;
    type stack is record
        top: pnode;
    end record;
end dstack;

