Inventory = {
	Items = {},
	ItemCount = 0,
}

function Inventory:AddItem( item )
	System:LogToConsole( "Add item to inventory..." );
	self.ItemCount = self.ItemCount + 1;
	self.Items[ self.ItemCount ] = item;
end

function Inventory:RemoveItem( itemid )
	System:LogToConsole( "Remove item to inventory..." );
	local i;
	self.ItemCount = self.ItemCount - 1;
	for i=itemid,self.ItemCount do
		self.Items[ i ] = self.Items[ i + 1 ];
	end
	self.Items[ self.ItemCount + 1 ] = nil;
end

function Inventory:GetItemCount()
	return self.ItemCount;
end

function Inventory:GetItem( itemid )
	return self.Items[ itemid ];
end

function Inventory:GetItemId( item )
	local checkitem;
	local i;
	for i, checkitem in self.Items do
		if ( checkitem == item ) then
			return i;
		end
	end
	return nil;
end

function Inventory:HasItem( item )
	local checkitem;
	local i;
	for i, checkitem in self.Items do
		if ( checkitem == item ) then
			return 1;
		end
	end
	return nil;
end

function Inventory:Reset()
	local checkitem;
	local i;
	for i, checkitem in self.Items do
		self.Items[ i ] = nil;
	end
	self.ItemCount = 0;
end