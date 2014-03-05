class Processing
	attr_accessor :cc, :mem

	def initialize credit_card, records
		@cc = credit_card
		@mem = records
	end

	def request
		@cc.split(" ").first
	end

	def cc_number
		entry = @cc.chomp.split(" ")
		entry[2].to_i
	end

	def cc_customer
		entry = @cc.chomp.split(" ")
		entry[1]
	end

	def cc_lim_cred_char
		@cc.chomp.split("$").last.to_i
	end

	def cc_validation
		card_number = cc_number.to_s.split('').map { |a| a.to_i }
		luhn_prep card_number
	end

	def luhn_prep card_number
		num_arr = []
		if card_number.size < 20
			if card_number.length.even?
				# length is even and should count off 2 , 1
				card_number.each_slice(2) do |x|
					num_arr << (x.first * 2)
					num_arr << (x.last)
				end
			else
				# length is odd and should count off 1 , 2
				card_number.each_slice(2) do |y|
					num_arr << (y.first)
					num_arr << (y.last * 2)
				end
			end

			results = luhn_proc num_arr

			if results == "valid"
				return 0
			else
				return "error"
			end
		end

		return "error"
	end

	def luhn_proc larr
		sum = 0
		larr.each do |num|
			if num > 9
				sum += (num % 10) + 1
			else
				sum += num
			end
		end

		if sum % 10 == 0
			return "valid"
		else
			return "invalid"
		end
	end

	def add_customer
		ac_arr = Array.new

		ac_arr << cc_number
		ac_arr << cc_lim_cred_char
		ac_arr << cc_validation
		ac_arr << cc_customer
		@mem << ac_arr
	end

	def charge_customer
		cust = cc_customer
		@mem.each do |rec|
			if rec[3] == cust && rec[2] != "error"
				temp = (rec[2] + cc_lim_cred_char)
				if temp <= rec[1]
					rec[2] = temp
				end
			end
		end
	end

	def credit_customer
		cust = cc_customer
		@mem.each do |rec|
			if rec[3] == cust && rec[2] != "error"
				rec[2] = (rec[2] - cc_lim_cred_char)
			end
		end
	end

	def output
		proc = request

		if proc.downcase == "add"
			add_customer
		elsif proc.downcase == "charge"
			charge_customer
		else
			credit_customer
		end
	end

end