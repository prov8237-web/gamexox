package lime.media.openal
{
   import lime.utils.ArrayBufferView;
   
   public class AL
   {
      
      public static var NONE:int;
      
      public static var FALSE:int;
      
      public static var TRUE:int;
      
      public static var SOURCE_RELATIVE:int;
      
      public static var CONE_INNER_ANGLE:int;
      
      public static var CONE_OUTER_ANGLE:int;
      
      public static var PITCH:int;
      
      public static var POSITION:int;
      
      public static var DIRECTION:int;
      
      public static var VELOCITY:int;
      
      public static var LOOPING:int;
      
      public static var BUFFER:int;
      
      public static var GAIN:int;
      
      public static var MIN_GAIN:int;
      
      public static var MAX_GAIN:int;
      
      public static var ORIENTATION:int;
      
      public static var SOURCE_STATE:int;
      
      public static var INITIAL:int;
      
      public static var PLAYING:int;
      
      public static var PAUSED:int;
      
      public static var STOPPED:int;
      
      public static var BUFFERS_QUEUED:int;
      
      public static var BUFFERS_PROCESSED:int;
      
      public static var REFERENCE_DISTANCE:int;
      
      public static var ROLLOFF_FACTOR:int;
      
      public static var CONE_OUTER_GAIN:int;
      
      public static var MAX_DISTANCE:int;
      
      public static var SEC_OFFSET:int;
      
      public static var SAMPLE_OFFSET:int;
      
      public static var BYTE_OFFSET:int;
      
      public static var SOURCE_TYPE:int;
      
      public static var STATIC:int;
      
      public static var STREAMING:int;
      
      public static var UNDETERMINED:int;
      
      public static var FORMAT_MONO8:int;
      
      public static var FORMAT_MONO16:int;
      
      public static var FORMAT_STEREO8:int;
      
      public static var FORMAT_STEREO16:int;
      
      public static var FREQUENCY:int;
      
      public static var BITS:int;
      
      public static var CHANNELS:int;
      
      public static var SIZE:int;
      
      public static var NO_ERROR:int;
      
      public static var INVALID_NAME:int;
      
      public static var INVALID_ENUM:int;
      
      public static var INVALID_VALUE:int;
      
      public static var INVALID_OPERATION:int;
      
      public static var OUT_OF_MEMORY:int;
      
      public static var VENDOR:int;
      
      public static var VERSION:int;
      
      public static var RENDERER:int;
      
      public static var EXTENSIONS:int;
      
      public static var DOPPLER_FACTOR:int;
      
      public static var SPEED_OF_SOUND:int;
      
      public static var DOPPLER_VELOCITY:int;
      
      public static var DISTANCE_MODEL:int;
      
      public static var INVERSE_DISTANCE:int;
      
      public static var INVERSE_DISTANCE_CLAMPED:int;
      
      public static var LINEAR_DISTANCE:int;
      
      public static var LINEAR_DISTANCE_CLAMPED:int;
      
      public static var EXPONENT_DISTANCE:int;
      
      public static var EXPONENT_DISTANCE_CLAMPED:int;
      
      public static var METERS_PER_UNIT:int;
      
      public static var DIRECT_FILTER:int;
      
      public static var AUXILIARY_SEND_FILTER:int;
      
      public static var AIR_ABSORPTION_FACTOR:int;
      
      public static var ROOM_ROLLOFF_FACTOR:int;
      
      public static var CONE_OUTER_GAINHF:int;
      
      public static var DIRECT_FILTER_GAINHF_AUTO:int;
      
      public static var AUXILIARY_SEND_FILTER_GAIN_AUTO:int;
      
      public static var AUXILIARY_SEND_FILTER_GAINHF_AUTO:int;
      
      public static var REVERB_DENSITY:int;
      
      public static var REVERB_DIFFUSION:int;
      
      public static var REVERB_GAIN:int;
      
      public static var REVERB_GAINHF:int;
      
      public static var REVERB_DECAY_TIME:int;
      
      public static var REVERB_DECAY_HFRATIO:int;
      
      public static var REVERB_REFLECTIONS_GAIN:int;
      
      public static var REVERB_REFLECTIONS_DELAY:int;
      
      public static var REVERB_LATE_REVERB_GAIN:int;
      
      public static var REVERB_LATE_REVERB_DELAY:int;
      
      public static var REVERB_AIR_ABSORPTION_GAINHF:int;
      
      public static var REVERB_ROOM_ROLLOFF_FACTOR:int;
      
      public static var REVERB_DECAY_HFLIMIT:int;
      
      public static var EAXREVERB_DENSITY:int;
      
      public static var EAXREVERB_DIFFUSION:int;
      
      public static var EAXREVERB_GAIN:int;
      
      public static var EAXREVERB_GAINHF:int;
      
      public static var EAXREVERB_GAINLF:int;
      
      public static var EAXREVERB_DECAY_TIME:int;
      
      public static var EAXREVERB_DECAY_HFRATIO:int;
      
      public static var EAXREVERB_DECAY_LFRATIO:int;
      
      public static var EAXREVERB_REFLECTIONS_GAIN:int;
      
      public static var EAXREVERB_REFLECTIONS_DELAY:int;
      
      public static var EAXREVERB_REFLECTIONS_PAN:int;
      
      public static var EAXREVERB_LATE_REVERB_GAIN:int;
      
      public static var EAXREVERB_LATE_REVERB_DELAY:int;
      
      public static var EAXREVERB_LATE_REVERB_PAN:int;
      
      public static var EAXREVERB_ECHO_TIME:int;
      
      public static var EAXREVERB_ECHO_DEPTH:int;
      
      public static var EAXREVERB_MODULATION_TIME:int;
      
      public static var EAXREVERB_MODULATION_DEPTH:int;
      
      public static var EAXREVERB_AIR_ABSORPTION_GAINHF:int;
      
      public static var EAXREVERB_HFREFERENCE:int;
      
      public static var EAXREVERB_LFREFERENCE:int;
      
      public static var EAXREVERB_ROOM_ROLLOFF_FACTOR:int;
      
      public static var EAXREVERB_DECAY_HFLIMIT:int;
      
      public static var CHORUS_WAVEFORM:int;
      
      public static var CHORUS_PHASE:int;
      
      public static var CHORUS_RATE:int;
      
      public static var CHORUS_DEPTH:int;
      
      public static var CHORUS_FEEDBACK:int;
      
      public static var CHORUS_DELAY:int;
      
      public static var DISTORTION_EDGE:int;
      
      public static var DISTORTION_GAIN:int;
      
      public static var DISTORTION_LOWPASS_CUTOFF:int;
      
      public static var DISTORTION_EQCENTER:int;
      
      public static var DISTORTION_EQBANDWIDTH:int;
      
      public static var ECHO_DELAY:int;
      
      public static var ECHO_LRDELAY:int;
      
      public static var ECHO_DAMPING:int;
      
      public static var ECHO_FEEDBACK:int;
      
      public static var ECHO_SPREAD:int;
      
      public static var FLANGER_WAVEFORM:int;
      
      public static var FLANGER_PHASE:int;
      
      public static var FLANGER_RATE:int;
      
      public static var FLANGER_DEPTH:int;
      
      public static var FLANGER_FEEDBACK:int;
      
      public static var FLANGER_DELAY:int;
      
      public static var FREQUENCY_SHIFTER_FREQUENCY:int;
      
      public static var FREQUENCY_SHIFTER_LEFT_DIRECTION:int;
      
      public static var FREQUENCY_SHIFTER_RIGHT_DIRECTION:int;
      
      public static var VOCAL_MORPHER_PHONEMEA:int;
      
      public static var VOCAL_MORPHER_PHONEMEA_COARSE_TUNING:int;
      
      public static var VOCAL_MORPHER_PHONEMEB:int;
      
      public static var VOCAL_MORPHER_PHONEMEB_COARSE_TUNING:int;
      
      public static var VOCAL_MORPHER_WAVEFORM:int;
      
      public static var VOCAL_MORPHER_RATE:int;
      
      public static var PITCH_SHIFTER_COARSE_TUNE:int;
      
      public static var PITCH_SHIFTER_FINE_TUNE:int;
      
      public static var RING_MODULATOR_FREQUENCY:int;
      
      public static var RING_MODULATOR_HIGHPASS_CUTOFF:int;
      
      public static var RING_MODULATOR_WAVEFORM:int;
      
      public static var AUTOWAH_ATTACK_TIME:int;
      
      public static var AUTOWAH_RELEASE_TIME:int;
      
      public static var AUTOWAH_RESONANCE:int;
      
      public static var AUTOWAH_PEAK_GAIN:int;
      
      public static var COMPRESSOR_ONOFF:int;
      
      public static var EQUALIZER_LOW_GAIN:int;
      
      public static var EQUALIZER_LOW_CUTOFF:int;
      
      public static var EQUALIZER_MID1_GAIN:int;
      
      public static var EQUALIZER_MID1_CENTER:int;
      
      public static var EQUALIZER_MID1_WIDTH:int;
      
      public static var EQUALIZER_MID2_GAIN:int;
      
      public static var EQUALIZER_MID2_CENTER:int;
      
      public static var EQUALIZER_MID2_WIDTH:int;
      
      public static var EQUALIZER_HIGH_GAIN:int;
      
      public static var EQUALIZER_HIGH_CUTOFF:int;
      
      public static var EFFECT_FIRST_PARAMETER:int;
      
      public static var EFFECT_LAST_PARAMETER:int;
      
      public static var EFFECT_TYPE:int;
      
      public static var EFFECT_NULL:int;
      
      public static var EFFECT_EAXREVERB:int;
      
      public static var EFFECT_REVERB:int;
      
      public static var EFFECT_CHORUS:int;
      
      public static var EFFECT_DISTORTION:int;
      
      public static var EFFECT_ECHO:int;
      
      public static var EFFECT_FLANGER:int;
      
      public static var EFFECT_FREQUENCY_SHIFTER:int;
      
      public static var EFFECT_VOCAL_MORPHER:int;
      
      public static var EFFECT_PITCH_SHIFTER:int;
      
      public static var EFFECT_RING_MODULATOR:int;
      
      public static var FFECT_AUTOWAH:int;
      
      public static var EFFECT_COMPRESSOR:int;
      
      public static var EFFECT_EQUALIZER:int;
      
      public static var EFFECTSLOT_EFFECT:int;
      
      public static var EFFECTSLOT_GAIN:int;
      
      public static var EFFECTSLOT_AUXILIARY_SEND_AUTO:int;
      
      public static var LOWPASS_GAIN:int;
      
      public static var LOWPASS_GAINHF:int;
      
      public static var HIGHPASS_GAIN:int;
      
      public static var HIGHPASS_GAINLF:int;
      
      public static var BANDPASS_GAIN:int;
      
      public static var BANDPASS_GAINLF:int;
      
      public static var BANDPASS_GAINHF:int;
      
      public static var FILTER_FIRST_PARAMETER:int;
      
      public static var FILTER_LAST_PARAMETER:int;
      
      public static var FILTER_TYPE:int;
      
      public static var FILTER_NULL:int;
      
      public static var FILTER_LOWPASS:int;
      
      public static var FILTER_HIGHPASS:int;
      
      public static var FILTER_BANDPASS:int;
       
      
      public function AL()
      {
      }
      
      public static function removeDirectFilter(param1:*) : void
      {
      }
      
      public static function removeSend(param1:*, param2:int) : void
      {
      }
      
      public static function auxf(param1:*, param2:int, param3:Number) : void
      {
      }
      
      public static function auxfv(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function auxi(param1:*, param2:int, param3:*) : void
      {
      }
      
      public static function auxiv(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function bufferData(param1:*, param2:int, param3:ArrayBufferView, param4:int, param5:int) : void
      {
      }
      
      public static function buffer3f(param1:*, param2:int, param3:Number, param4:Number, param5:Number) : void
      {
      }
      
      public static function buffer3i(param1:*, param2:int, param3:int, param4:int, param5:int) : void
      {
      }
      
      public static function bufferf(param1:*, param2:int, param3:Number) : void
      {
      }
      
      public static function bufferfv(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function bufferi(param1:*, param2:int, param3:int) : void
      {
      }
      
      public static function bufferiv(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function createAux() : *
      {
         return null;
      }
      
      public static function createBuffer() : *
      {
         return null;
      }
      
      public static function createEffect() : *
      {
         return null;
      }
      
      public static function createFilter() : *
      {
         return null;
      }
      
      public static function createSource() : *
      {
         return null;
      }
      
      public static function deleteBuffer(param1:*) : void
      {
      }
      
      public static function deleteBuffers(param1:Array) : void
      {
      }
      
      public static function deleteSource(param1:*) : void
      {
      }
      
      public static function deleteSources(param1:Array) : void
      {
      }
      
      public static function disable(param1:int) : void
      {
      }
      
      public static function distanceModel(param1:int) : void
      {
      }
      
      public static function dopplerFactor(param1:Number) : void
      {
      }
      
      public static function dopplerVelocity(param1:Number) : void
      {
      }
      
      public static function effectf(param1:*, param2:int, param3:Number) : void
      {
      }
      
      public static function effectfv(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function effecti(param1:*, param2:int, param3:int) : void
      {
      }
      
      public static function effectiv(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function enable(param1:int) : void
      {
      }
      
      public static function genSource() : *
      {
         return null;
      }
      
      public static function genSources(param1:int) : Array
      {
         return null;
      }
      
      public static function genBuffer() : *
      {
         return null;
      }
      
      public static function genBuffers(param1:int) : Array
      {
         return null;
      }
      
      public static function getBoolean(param1:int) : Boolean
      {
         return false;
      }
      
      public static function getBooleanv(param1:int, param2:int = 1) : Array
      {
         return null;
      }
      
      public static function getBuffer3f(param1:*, param2:int) : Array
      {
         return null;
      }
      
      public static function getBuffer3i(param1:*, param2:int) : Array
      {
         return null;
      }
      
      public static function getBufferf(param1:*, param2:int) : Number
      {
         return 0;
      }
      
      public static function getBufferfv(param1:*, param2:int, param3:int = 1) : Array
      {
         return null;
      }
      
      public static function getBufferi(param1:*, param2:int) : int
      {
         return 0;
      }
      
      public static function getBufferiv(param1:*, param2:int, param3:int = 1) : Array
      {
         return null;
      }
      
      public static function getDouble(param1:int) : Number
      {
         return 0;
      }
      
      public static function getDoublev(param1:int, param2:int = 1) : Array
      {
         return null;
      }
      
      public static function getEnumValue(param1:String) : int
      {
         return 0;
      }
      
      public static function getError() : int
      {
         return 0;
      }
      
      public static function getErrorString() : String
      {
         var _loc1_:int = AL.getError();
         if(_loc1_ == 40961)
         {
            return "INVALID_NAME: Invalid parameter name";
         }
         if(_loc1_ == 40962)
         {
            return "INVALID_ENUM: Invalid enum value";
         }
         if(_loc1_ == 40963)
         {
            return "INVALID_VALUE: Invalid parameter value";
         }
         if(_loc1_ == 40964)
         {
            return "INVALID_OPERATION: Illegal operation or call";
         }
         if(_loc1_ == 40965)
         {
            return "OUT_OF_MEMORY: OpenAL has run out of memory";
         }
         return "";
      }
      
      public static function getFilteri(param1:*, param2:int) : int
      {
         return 0;
      }
      
      public static function getFloat(param1:int) : Number
      {
         return 0;
      }
      
      public static function getFloatv(param1:int, param2:int = 1) : Array
      {
         return null;
      }
      
      public static function getInteger(param1:int) : int
      {
         return 0;
      }
      
      public static function getIntegerv(param1:int, param2:int = 1) : Array
      {
         return null;
      }
      
      public static function getListener3f(param1:int) : Array
      {
         return null;
      }
      
      public static function getListener3i(param1:int) : Array
      {
         return null;
      }
      
      public static function getListenerf(param1:int) : Number
      {
         return 0;
      }
      
      public static function getListenerfv(param1:int, param2:int = 1) : Array
      {
         return null;
      }
      
      public static function getListeneri(param1:int) : int
      {
         return 0;
      }
      
      public static function getListeneriv(param1:int, param2:int = 1) : Array
      {
         return null;
      }
      
      public static function getParameter(param1:int) : *
      {
         return null;
      }
      
      public static function getProcAddress(param1:String) : *
      {
         return null;
      }
      
      public static function getSource3f(param1:*, param2:int) : Array
      {
         return null;
      }
      
      public static function getSourcef(param1:*, param2:int) : Number
      {
         return 0;
      }
      
      public static function getSource3i(param1:*, param2:int) : Array
      {
         return null;
      }
      
      public static function getSourcefv(param1:*, param2:int, param3:int = 1) : Array
      {
         return null;
      }
      
      public static function getSourcei(param1:*, param2:int) : *
      {
         return 0;
      }
      
      public static function getSourceiv(param1:*, param2:int, param3:int = 1) : Array
      {
         return null;
      }
      
      public static function getString(param1:int) : String
      {
         return null;
      }
      
      public static function isBuffer(param1:*) : Boolean
      {
         return false;
      }
      
      public static function isEnabled(param1:int) : Boolean
      {
         return false;
      }
      
      public static function isExtensionPresent(param1:String) : Boolean
      {
         return false;
      }
      
      public static function isAux(param1:*) : Boolean
      {
         return false;
      }
      
      public static function isEffect(param1:*) : Boolean
      {
         return false;
      }
      
      public static function isFilter(param1:*) : Boolean
      {
         return false;
      }
      
      public static function isSource(param1:*) : Boolean
      {
         return false;
      }
      
      public static function listener3f(param1:int, param2:Number, param3:Number, param4:Number) : void
      {
      }
      
      public static function listener3i(param1:int, param2:int, param3:int, param4:int) : void
      {
      }
      
      public static function listenerf(param1:int, param2:Number) : void
      {
      }
      
      public static function listenerfv(param1:int, param2:Array) : void
      {
      }
      
      public static function listeneri(param1:int, param2:int) : void
      {
      }
      
      public static function listeneriv(param1:int, param2:Array) : void
      {
      }
      
      public static function source3f(param1:*, param2:int, param3:Number, param4:Number, param5:Number) : void
      {
      }
      
      public static function source3i(param1:*, param2:int, param3:*, param4:int, param5:int) : void
      {
      }
      
      public static function sourcef(param1:*, param2:int, param3:Number) : void
      {
      }
      
      public static function sourcefv(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function sourcei(param1:*, param2:int, param3:*) : void
      {
      }
      
      public static function filteri(param1:*, param2:int, param3:*) : void
      {
      }
      
      public static function filterf(param1:*, param2:int, param3:Number) : void
      {
      }
      
      public static function sourceiv(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function sourcePlay(param1:*) : void
      {
      }
      
      public static function sourcePlayv(param1:Array) : void
      {
      }
      
      public static function sourceStop(param1:*) : void
      {
      }
      
      public static function sourceStopv(param1:Array) : void
      {
      }
      
      public static function sourceRewind(param1:*) : void
      {
      }
      
      public static function sourceRewindv(param1:Array) : void
      {
      }
      
      public static function sourcePause(param1:*) : void
      {
      }
      
      public static function sourcePausev(param1:Array) : void
      {
      }
      
      public static function sourceQueueBuffer(param1:*, param2:*) : void
      {
      }
      
      public static function sourceQueueBuffers(param1:*, param2:int, param3:Array) : void
      {
      }
      
      public static function sourceUnqueueBuffer(param1:*) : *
      {
         return 0;
      }
      
      public static function sourceUnqueueBuffers(param1:*, param2:int) : Array
      {
         return null;
      }
      
      public static function speedOfSound(param1:Number) : void
      {
      }
   }
}
