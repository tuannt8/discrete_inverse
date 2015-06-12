function [a,b,c,fa,fb,fc] = db_mnbrak(func_name)

% This is the mnbrak routine, page 400 of [Numerical recipes in C]. Gives numbers a,b and c 
% that satisfy f(x+b*xi) < f(x+a*xi) and f(x+b*xi) < f(x+c*xi).
%
% Samuli Siltanen Feb 2001

global POINT DIRECTION MEAS_IMAG ROW COL REGPARAM BETA G_PSF

gold   = 1.618034;   % The golden ratio
glimit = 100;

% Initial guess for brackets.
a = 0; 
b = 1;        

evalcommand = ['fa = ',func_name,'(a);']; 
eval(evalcommand);
evalcommand = ['fb = ',func_name,'(b);']; 
eval(evalcommand);

% Switch to downhill situation if needed
if fb > fa         
   tmp = a;  a  = b;  b  = tmp;
   tmp = fa; fa = fb; fb = tmp;
end

c = b+gold*(b-a);

evalcommand = ['fc = ',func_name,'(c);']; 
eval(evalcommand);

while fb > fc
   r    = (b-a)*(fb-fc);
   q    = (b-c)*(fb-fa);
   u    = b-((b-c)*q-(b-a)*r)/(2*(sign(q-r)^sign(q-r))*max((q-r),1e-16));
   ulim = b+glimit*(c-b);   
   if (b-u)*(u-c) > 0 %Parabolic u is between b and c
      evalcommand = ['fu = ',func_name,'(u);']; 
      eval(evalcommand);
      
      if fu < fc      % Got minimum between b and c
         a  = b;
         b  = u;
         fa = fb;
         fb = fu;
      elseif fu > fb  % Got minimum between a and u
         c  = u;
         fc = fu;
      end
      
      u = c+gold*(c-b);
      evalcommand = ['fu = ',func_name,'(u);']; 
      eval(evalcommand);
      
   elseif (c-u)*(u-ulim) > 0 % Parabolic u is between c and ulim
      evalcommand = ['fu = ',func_name,'(u);']; 
      eval(evalcommand);
      
      if fu < fc
         b  = c;  
         c  = u;  
         u  = c+gold*(c-b);
         fb = fc;
         fc = fu;
         
         evalcommand = ['fu = ',func_name,'(u);']; 
         eval(evalcommand);
      end
      
   elseif (u-ulim)*(ulim-c) >=  0 %Limit u to its maximum allowed value
      u = ulim; 
      evalcommand = ['fu = ',func_name,'(u);']; 
      eval(evalcommand);
   else % Reject parabolic u, use default magnification
      u = c+gold*(c-b);
      evalcommand = ['fu = ',func_name,'(u);']; 
      eval(evalcommand);
   end
   %Eliminate oldest point and continue
   a  = b;  
   b  = c;  
   c  = u;
   fa = fb;
   fb = fc;
   fc = fu;
end
