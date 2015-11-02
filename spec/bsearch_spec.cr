#coding:utf-8
require "./spec_helper"

# test case acknowledgement:
# https://github.com/ruby/ruby/blob/trunk/test/ruby/test_array.rb
# https://github.com/ruby/ruby/blob/trunk/test/ruby/test_range.rb

describe "Range#bsearch" do
	it "Int" do
		ary = [3, 4, 7, 9, 12]
		(0...ary.size).bsearch{|i| ary[i] >= 2 }.should eq 0
		(0...ary.size).bsearch{|i| ary[i] >= 4 }.should eq 1
		(0...ary.size).bsearch{|i| ary[i] >= 6 }.should eq 2
		(0...ary.size).bsearch{|i| ary[i] >= 8 }.should eq 3
		(0...ary.size).bsearch{|i| ary[i] >= 10 }.should eq 4
		(0...ary.size).bsearch{|i| ary[i] >= 100 }.should eq nil
		(0...ary.size).bsearch{|i| true }.should eq 0
		(0...ary.size).bsearch{|i| false }.should eq nil

		ary = [0, 100, 100, 100, 200]
		(0...ary.size).bsearch{|i| ary[i] >= 100 }.should eq 1
	end
	it "Float" do
		pending "not ported yet due to reinterpreting" do
		end
	end
end

describe "Array#bsearch" do
	it "minimum_mode" do
		a = [0, 4, 7, 10, 12]
		a.bsearch{|x| x >=   4 }.should eq 4
		a.bsearch{|x| x >=   6 }.should eq 7
		a.bsearch{|x| x >=  -1 }.should eq 0
		a.bsearch{|x| x >= 100 }.should eq nil
	end
	it "any mode" do
		a = [0, 4, 7, 10, 12]
		(4..7).should contain a.bsearch{|x| 1 - x / 4}.not_nil!
		a.bsearch{|x| 4 - x / 2 }.should eq nil
		a.bsearch{|x| 1 }.should eq nil
		a.bsearch{|x| -1 }
	end
end

describe "Array#bsearch_index" do
	it "minimum_mode" do
		a = [0, 4, 7, 10, 12]
		a.bsearch_index{|x| x >=   4 }.should eq 1
		a.bsearch_index{|x| x >=   6 }.should eq 2
		a.bsearch_index{|x| x >=  -1 }.should eq 0
		a.bsearch_index{|x| x >= 100 }.should eq nil
	end
	it "any mode" do
		a = [0, 4, 7, 10, 12]
		(1..2).should contain a.bsearch_index{|x| 1 - x / 4}.not_nil!
		a.bsearch_index{|x| 4 - x / 2 }.should eq nil
		a.bsearch_index{|x| 1 }.should eq nil
		a.bsearch_index{|x| -1 }
	end
end
