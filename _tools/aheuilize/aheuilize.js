function divide( a )
{
	var b = Math.floor( a/2 );
	if( a%2 == 1 ) return [ b, b+1 ];
	else return [ b, b ];
}

function factorization( a )
{
	var primes = [];
	var factor = 2;
	if( a<2 ) return [ a ];
	while( a>1 )
	{
		while( a%factor ) ++factor;
		primes.push( factor );
		a = Math.floor( a/factor );
	}
	return primes;
}

function compressFactors( a )
{
	var isFirst2 = true;
	var isFirst3 = true;
	var cnt2 = 0;
	var cnt3 = 0;
	var result = [];
	for( var i=0; i<a.length; ++i )
	{
		if( a[ i ]==2 )
		{
			++cnt2;
			if( isFirst2 ) isFirst2=false;
			else if( !( cnt2%3 ) ) result.push( 8 );
		} else if( a[ i ]==3 )
		{
			++cnt3;
			if( isFirst3 ) isFirst3=false;
			else if( !( cnt3%2 ) ) result.push( 9 );
		} else result.push( a[ i ] );
	}
	if( cnt2%3==2 ) result.push( 4 );
	else if( cnt2%3==1 ) result.push( 2 );
	if( cnt3%2==1 ) result.push( 3 );
	return result;
}

function isPrime( a )
{
	var sqrt = Math.floor( Math.sqrt( a ) );
	if( a<2 ) return false;
	for( var i=2; a%i&&i<=sqrt; ++i );
	return sqrt+1 == i;
}

function number2Aheui( a )
{
	var i;
	var cnt =- 1;
	var result = "";
	var divided;
	var compressed;
	var table = [
		"바", "받반타", "반", "받", "밤",
		"발", "밦", "밝", "밣", "밢"
	];
	if( a<10 ) return table[ a ];
	if( isPrime( a ) )
	{
		divided = divide( a );
		for( i=0; i<divided.length; ++i )
			result += number2Aheui( divided[ i ] );
		result += "다";
		return result;
	} else {
		compressed = compressFactors( factorization( a ) );
		for( i=0; i<compressed.length; ++i )
			result += number2Aheui( compressed[ i ] ), ++cnt;
		for( i=0; i<cnt; ++i )
			result += "따";
		return result;
	}
}

function trace2Aheui( a )
{
	var result = "";
	for( var i=0; i<a.length; ++i )
		result += number2Aheui( a.charCodeAt( i ) )+"맣";
	return result;
}