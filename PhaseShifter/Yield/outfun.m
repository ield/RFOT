function stop=outfun(x,optimValues,state)

if strcmp(state,'iter')
      disp(x);
end
   
stop=false;

end