package body dstack is
   procedure push(s: in out stack; e: element) is
      newNode: pnode;
   begin
      newNode := new node;
      newNode.all.next := s.top;
      newNode.all.e := e;
      s.top := newNode;
   end;

   procedure pop(s: in out stack) is
   begin
      if s.top /= null then
         s.top := s.top.next;
      else
         raise empty_stack;
      end if;
   end;

   procedure empty(s: in out stack) is
   begin
      s.top := null;
   end;    

   function top(s: in stack) return element is
   begin
      if s.top = null then raise empty_stack; end if;
      return s.top.all.e;
   end;
   
   function is_empty (s: in stack) return Boolean is 
   begin 
      return s.top = null;
   end is_empty;
end dstack;
