require 'spec_helper'

describe Processing do
	
	before :each do
		@process = Processing.new "Add Tom 4111111111111111 $1000", []
	end

	describe "#new" do
		it "returns an object of Processing" do
			@process.should be_an_instance_of Processing
		end
	end

	describe "#cc" do
		it "returns an input card request" do
			@process.cc.should eql "Add Tom 4111111111111111 $1000"
		end
	end

	describe "request" do
		it "returns an Add processing request" do
			@process.request.should eql "Add"
		end

		it "returns a Charge processing request" do
			@process = Processing.new "Charge Tom $500", []
			@process.request.should eql "Charge"
		end

		it "returns a Credit processing request" do
			@process = Processing.new "Credit Lisa $100", []
			@process.request.should eql "Credit"
		end
	end

	describe "cc_number" do
		it "returns a credit card number to be created" do
			@process.cc_number.should eql 4111111111111111
		end
	end

	describe "cc_customer" do
		it "returns the name of the card holder being created" do
			@process.cc_customer.should eql "Tom"
		end

		it "returns the name of the card holder being charged" do
			@process = Processing.new "Charge Tom $500", []
			@process.cc_customer.should eql "Tom"
		end

		it "returns the name of the card holder being credited" do
			@process = Processing.new "Credit Quincy $200", []
			@process.cc_customer.should eql "Quincy"
		end
	end

	describe "cc_lim_cred_char" do
		it "returns the credit card limit" do
			@process.cc_lim_cred_char.should eql 1000
		end
	end

	describe "cc_validation" do
		it "returns a zero balance if card number is valid" do
			@process.cc_validation.should eql 0
		end

		it "returns 'error' alert if card is invalid" do
			@process = Processing.new "Add Quincy 1234567890123456 $2000", []
			@process.cc_validation.should eql "error"
		end

		it "returns 'error' alert for card numbers with length > 19" do
			@process = Processing.new "Add Harry 4121211111111112611112 $3500", []
			@process.cc_validation.should eql "error"
		end

	end

	describe "add_customer" do
		it "returns an array of a new account" do
			@process.add_customer.should eql [[4111111111111111, 1000, 0, "Tom"]]
		end

		it "returns an array with bad information" do
			@process = Processing.new "Add Quincy 1234567890123456 $2000", []
			@process.add_customer.should eql [[1234567890123456, 2000, "error", "Quincy"]]
		end
	end

	describe "charge_customer" do
		it "returns an array with an adjusted balance < limit" do
			@process = Processing.new "Charge Tom $500", [[4111111111111111, 1000, 0, "Tom"]]
			@process.output.should eql [[4111111111111111, 1000, 500, "Tom"]]
		end

		it "returns an array with an unadjusted balance < limit" do
			@process = Processing.new "Charge Tom $1000", [[4111111111111111, 1000, 500, "Tom"]]
			@process.output.should eql [[4111111111111111, 1000, 500, "Tom"]]
		end

		it "returns an array with an unadjustable balance with invalid card" do
			@process = Processing.new "Charge Quincy $200", [[1234567890123456, 2000, "error", "Quincy"]]
			@process.output.should eql [[1234567890123456, 2000, "error", "Quincy"]]
		end
	end

	describe "credit_customer" do
		it "returns an array with an adjusted balance < limit" do
			@process = Processing.new "Credit Tom $100", [[4111111111111111, 1000, 500, "Tom"]]
			@process.output.should eql [[4111111111111111, 1000, 400, "Tom"]]
		end

		it "returns an array with a negative balance when credit > balance" do
			@process = Processing.new "Credit Tom $600", [[4111111111111111, 1000, 500, "Tom"]]
			@process.output.should eql [[4111111111111111, 1000, -100, "Tom"]]
		end

		it "returns an array with an unadjustable balance with invalid card" do
			@process = Processing.new "Credit Quincy $200", [[1234567890123456, 2000, "error", "Quincy"]]
			@process.output.should eql [[1234567890123456, 2000, "error", "Quincy"]]
		end
	end

end