( function _Process_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    let _ = require( '../../../../wtools/Tools.s' );
  }
  catch( err )
  {
    let _ = require( '../../../wtools/Tools.s' );
  }

  let _ = _global_.wTools;
  _.include( 'wTesting' );
  require( '../../l9/consequence/Namespace.s' );
}

let _global = _global_;
let _ = _global_.wTools;

// --
// test
// --

function ready( test )
{
  let t1 = 10;
  let t2 = 100;
  let ready =  new _.Consequence().take( null );

  /* */

  ready.then( () =>
  {
    test.case = 'without arguments';
    var proceduresBefore = _.Procedure.Counter;
    var got = _.process.ready();
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 2 );
    test.is( _.consequenceIs( got ) );

    return null;
  });

  ready.then( () =>
  {
    test.case = 'only onReady, no timeOut';
    var arr = [];
    var onReady = () => arr.push( 1 );
    var proceduresBefore = _.Procedure.Counter;
    _.process.ready( onReady );
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 2 );

    return _.time.out( t2, () =>
    {
      test.identical( arr, [ 1 ] );
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'timeOut and onReady';
    var arr = [];
    var onReady = () => arr.push( 1 );
    var proceduresBefore = _.Procedure.Counter;
    _.process.ready( t2, onReady );
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 2 );
    test.identical( arr, [] );

    return _.time.out( t2 * 2, () =>
    {
      test.identical( arr, [ 1 ] );
      return null;
    });
  });

  /* */

  ready.then( () =>
  {
    test.case = 'empty map';
    var proceduresBefore = _.Procedure.Counter;
    var got = _.process.ready( {} );
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 2 );
    test.is( _.consequenceIs( got ) );

    return null;
  });

  ready.then( () =>
  {
    test.case = 'only timeOut';
    var proceduresBefore = _.Procedure.Counter;
    var got = _.process.ready({ timeOut : t1 });
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 2 );
    test.identical( got.resourcesCount(), 0 );

    return _.time.out( t2, () =>
    {
      test.identical( got.resourcesCount(), 1 );
    });
  });

  ready.then( () =>
  {
    test.case = 'only onReady, no timeOut, no procedure';
    var arr = [];
    var onReady = () => arr.push( 1 );
    var proceduresBefore = _.Procedure.Counter;
    _.process.ready({ onReady });
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 2 );

    return _.time.out( t2, () =>
    {
      test.identical( arr, [ 1 ] );
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'only procedure, no timeOut, no onReady';
    var procedure = _.Procedure( 2 );
    var proceduresBefore = _.Procedure.Counter;
    _.process.ready({ procedure });
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 1 );

    return null;
  });

  ready.then( () =>
  {
    test.case = 'timeOut and onReady';
    var arr = [];
    var onReady = () => arr.push( 1 );
    var proceduresBefore = _.Procedure.Counter;
    _.process.ready({ timeOut : t1, onReady });
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 2 );
    test.identical( arr, [] );

    return _.time.out( t2 * 2, () =>
    {
      test.identical( arr, [ 1 ] );
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'timeOut and procedure';
    var procedure = _.Procedure( 2 );
    var proceduresBefore = _.Procedure.Counter;
    var got = _.process.ready({ timeOut : t1, procedure });
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 1 );
    test.identical( got.resourcesCount(), 0 );

    return _.time.out( t2 * 2, () =>
    {
      test.identical( got.resourcesCount(), 1 );
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'onReady and procedure';
    var arr = [];
    var procedure = _.Procedure( 2 );
    var onReady = () => arr.push( 1 );
    var proceduresBefore = _.Procedure.Counter;
    _.process.ready({ procedure, onReady });
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 1 );
    test.identical( arr, [] );

    return _.time.out( t2 * 2, () =>
    {
      test.identical( arr, [ 1 ] );
      return null;
    });
  });

  ready.then( () =>
  {
    test.case = 'timeOut, onReady and procedure';
    var arr = [];
    var procedure = _.Procedure( 2 );
    var onReady = () => arr.push( 1 );
    var proceduresBefore = _.Procedure.Counter;
    _.process.ready({ timeOut : t1, procedure, onReady });
    var proceduresAfter = _.Procedure.Counter;
    test.identical( proceduresAfter - proceduresBefore, 1 );
    test.identical( arr, [] );

    return _.time.out( t2 * 2, () =>
    {
      test.identical( arr, [ 1 ] );
      return null;
    });
  });

  /* - */

  if( !Config.debug )
  return;

  test.case = 'single arg is not a routine';
  test.shouldThrowErrorSync( () => _.process.ready( 1 ) );

  test.case = 'wrong type of timeOut';
  test.shouldThrowErrorSync( () => _.process.ready( 'wrong', () => 'ready' ) );
  test.shouldThrowErrorSync( () => _.process.ready( 10.5, () => 'ready' ) );
  test.shouldThrowErrorSync( () => _.process.ready( Infinity, () => 'ready' ) );

  test.case = 'wrong type of onReady';
  test.shouldThrowErrorSync( () => _.process.ready( 10, 'wrong' ) );

  test.case = 'options map has not known option';
  test.shouldThrowErrorSync( () => _.process.ready({ timeOut : 10, unknown : 'unknown', onReady : () => 'ready' }) );

  return ready;
}

ready.timeOut = 10000;


// --
// declare
// --

let Self =
{

  name : 'Tools/consequence/Process',
  silencing : 1,
  enabled : 1,

  tests :
  {

    ready,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();

