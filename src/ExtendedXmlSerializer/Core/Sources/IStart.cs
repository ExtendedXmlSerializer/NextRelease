using System.Collections.Generic;

namespace ExtendedXmlSerializer.Core.Sources
{
	interface IStart<out T> : IEnumerable<T> {}
}