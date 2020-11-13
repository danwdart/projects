root {
  NS <- 5;
}-{
  *:countdown;
}

countdown {
  Stdout <- NS;
  NS <- 0->* | -1 <- NS;
}-{
  >0:countdown;
}
