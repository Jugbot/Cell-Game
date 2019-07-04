
math.gratio = (1 + math.sqrt(5))/2
function math.nthgratio(itr, number)
  number = number or math.gratio
  if itr == 0 then return number end
  return math.nthgratio(itr-1, number * math.gratio)
end