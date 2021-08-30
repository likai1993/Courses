class Statistics {
 public:
  Statistics();
  ~Statistics();

  uint64_t longterm_length;
  uint64_t midterm_length;
  uint64_t shortterm_length;

  vector<int> vect_l(longterm_length); 
  vector<int> vect_m(midterm_length); 
  vector<int> vect_s(shortterm_length); 

  float longterm_weight;
  float midterm_weight;
  float shortterm_weight;
 
  float boundary; // larger than this value is write-intensive, smaller than it would be read-intensive
  // TODO set a safe boundary window to avoid sharp turn-around
  
  float CalculateFeature(); // long/mid/short term stats collectively decide the workload feature 

  void AWrite();
  void ARead();
  bool Reset() override;

 private:
  uint64_t longterm_read;
  uint64_t longterm_write;

  uint64_t midterm_read;
  uint64_t midterm_write;

  uint64_t shortterm_read;
  uint64_t shortterm_write;
}
