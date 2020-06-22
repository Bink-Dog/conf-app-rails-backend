require 'square'
 
# Create an instance of the API Client and initialize it with the credentials 
# for the Square account whose assets you want to manage.

client = Square::Client.new(
    access_token: 'EAAAEKOYkzsENSH7BanFgLVh-U3Kbkuaj-2Hf2ju2LR85EuPuvX8bEb7iathafMM',
    environment: 'sandbox'
)

# Call list_locations method to get all locations in this Square account
result = client.locations.list_locations

# Call the #success? method to see if the call succeeded
if result.success?
	# The #data Struct contains a list of locations
  locations = result.data.locations

	# Iterate over the list
  locations.each do |location|
    # Each location is represented as a Hash
    location.each do |key, value|
      puts "#{key}: #{value}"
    end
  end
else
  # Handle the case that the result is an error.
  warn 'Error calling LocationsApi.listlocations ...'

  # The #errors method returns an Array of error Hashes
  result.errors.each do |key, value|
    warn "#{key}: #{value}"
  end
end