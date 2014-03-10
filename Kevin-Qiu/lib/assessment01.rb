# Kevin Qiu

def factors(num)
  [].tap do |factors_arr|
    1.upto(num) do |factor|
      factors_arr << factor if num % factor == 0
    end
  end
end

def fibs_rec(count)
  return [0]   if count == 1
  return [0,1] if count == 2

  x = fibs_rec(count-1)
  x + [x[-1] + x[-2]]
end

class Array
  def bubble_sort(&prc)
    dup.bubble_sort!(&prc)
  end

  def bubble_sort!(&prc)
    prc = Proc.new{|i,j| i<=>j } unless prc
    begin
      sorted = true
      each_index do |i|
        if prc.call(self[i],self[i+1]) == 1
          self[i], self[i+1] = self[i+1], self[i]
          sorted = false
        end
      end
    end until sorted == true
    self
  end
end

class Array
  def two_sum
    [].tap do |two_sums|
      each_index do |left_i|
        (left_i+1...length).each do |right_i|
          left_num, right_num = self[left_i], self[right_i]
          two_sums << [left_i,right_i] if left_num + right_num == 0
        end
      end
    end
  end
end

class String
  def subword_counts(dictionary)
    Hash.new(0).tap do |word_count|
      (0..length).each do |sub_len|
        (0...length-sub_len).each do |i|
          substr = self[i..i+sub_len]
          word_count[substr] += 1 if dictionary.include?(substr)
        end
      end
    end
  end
end
