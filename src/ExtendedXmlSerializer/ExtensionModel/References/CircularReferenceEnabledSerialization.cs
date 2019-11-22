using ExtendedXmlSerializer.ContentModel.Content;
using ExtendedXmlSerializer.ContentModel.Format;
using System.Reflection;

namespace ExtendedXmlSerializer.ExtensionModel.References
{
	class CircularReferenceEnabledSerialization : ISerializers
	{
		readonly ISerializers _context;

		public CircularReferenceEnabledSerialization(ISerializers context) => _context = context;

		public ContentModel.ISerializer Get(TypeInfo parameter) => new Container(_context.Get(parameter));

		sealed class Container : ContentModel.ISerializer
		{
			readonly ContentModel.ISerializer _serializer;

			public Container(ContentModel.ISerializer serializer) => _serializer = serializer;

			public object Get(IFormatReader parameter) => _serializer.Get(parameter);

			public void Write(IFormatWriter writer, object instance)
			{
				try
				{
					_serializer.Write(writer, instance);
				}
				catch (CircularReferencesDetectedException e)
				{
					e.Writer.Write(writer, instance);
				}
			}
		}
	}
}