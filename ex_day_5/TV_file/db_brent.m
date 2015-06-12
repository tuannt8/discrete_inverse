function [t,ft] = db_brent(a,b,c,func_name,TOL)

global POINT DIRECTION MEAS_IMAG ROW COL REGPARAM BETA G_PSF

%Initializations
cgold=0.3819660;
%Arrange bracket endpoints to ascending order
a_brac=a;b_brac=b;c_brac=c;
if a_brac>c_brac 
   a=c_brac;
   b=a_brac; 
else 
   b=c_brac; 
end

e=0;d=0;
t=b_brac;
v=b_brac;
w=b_brac;
evalcommand=['ft=',func_name,'(t);']; eval(evalcommand);
fv=ft; fw=ft;
tol1=TOL*abs(t)+1e-12;
tol2=2*tol1;
tm=(b+a)/2;
while abs(t-tm) > tol2-(b-a)/2
   tm=(b+a)/2;
   tol1=TOL*abs(t)+1e-12;
   tol2=2*tol1;
   if abs(e) > tol1
      r=(t-w)*(ft-fv);
      q=(t-v)*(ft-fw);
      p=(t-v)*q-(t-w)*r;
      q=2*(q-r);
      if q > 0, p=-p; end
      q=abs(q);
      etmp=e;
      e=d;
      if (abs(p) >= abs(q*etmp/2)) | (p <= q*(a-t)) | (p >= (b-t))
         %Choosing the golden ratio step
         if t >= tm, e=a-t; else e=b-t; end
         d=cgold*e;
      else
         %Choosing the parabolic step
         d=p/q;
         u=t+d;
         if (u-a < tol2) | (b-u < tol2)
            d=sign(tm-t)^sign(tm-t)*tol1;
         end
      end
   else
      if t >= tm, e=a-t; else e=b-t; end
      d=cgold*e;      
   end
   if abs(d) >= tol1
      u=t+d;
   else
      u=t+sign(d)^sign(d)*tol1;
   end
   %The only function evaluation in one line minimization iteration
   evalcommand=['fu=',func_name,'(u);']; eval(evalcommand);
   if fu <= ft
      if u >= t, a=t; else b=t; end
      v=w; w=t; t=u; fv=fw; fw=ft; ft=fu;
   else
      if u < t, a=u; else b=u; end
      if (fu <= fw) | (w == t)
         v=w; w=u; fv=fw; fw=fu;
      elseif (fu <= fv) | (v == t) | (v == w)
         v=u; fv=fu;
      end
   end
   %disp(abs(t-tm))   
end
