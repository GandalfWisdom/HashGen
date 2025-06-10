--!strict
--[=[
	A module for generating and reusing incremental hashes. Useful for things like enemy IDs.
]=]
local HashGen = {};
local hash_table: { [string]:{ [number]: boolean } } = {};

--[=[
	Generates a new hash or reuses an old inactive hash.
	@param category_name string -- Name of the hash category. For example "Boxes", "Enemies", etc. 
	@return hash number -- Returns the unique/reused hash.
]=]
function HashGen.new_hash(category_name: string): number
	assert(category_name ~= nil, "Hash function not supplied with necessary category_name string!");
	hash_table[category_name] = hash_table[category_name] or {}; --Ensure category exists.
    --Checks for existing inactive hash. Returns if found. Also acts as a guard clause
    for old_hash, active in pairs(hash_table[category_name]) do
        if (active == false) then 
			hash_table[category_name][old_hash] = true; 
			return old_hash;
		end;
    end;
	
	local next_index: number = 1;
	while (hash_table[category_name][next_index] ~= nil) do -- Loops through table until it finds an empty index.
		next_index += 1;
	end;
	hash_table[category_name][next_index] = true;
    return next_index;
end;

--[=[
	Set's hash active to specified boolean value.
	@param category string -- Hash category.
	@param hash number -- Hash ID.
	@param active boolean -- State of the hash.
]=]
function HashGen.set_active_hash(category: string, hash: number, active: boolean): ()
	if not (hash_table[category]) then return; end; -- Guard clause.
	if (hash_table[category][hash] == nil) then return; end; -- Guard clause.
	hash_table[category][hash] = active;
end;

return HashGen;