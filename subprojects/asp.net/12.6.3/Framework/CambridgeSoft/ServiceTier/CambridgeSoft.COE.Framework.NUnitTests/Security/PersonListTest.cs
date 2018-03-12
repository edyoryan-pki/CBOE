﻿using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using NUnit.Framework;
using CambridgeSoft.COE.Framework.NUnitTests.Helpers;
using CambridgeSoft.COE.Framework.COESecurityService;
using System.Reflection;

namespace CambridgeSoft.COE.Framework.NUnitTests.Security
{
    /// <summary>
    /// Summary description for PersonListTest
    /// </summary>
    [TestFixture]
    public class PersonListTest
    {
        public PersonListTest()
        {            
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        [TestFixtureSetUp]
        public static void MyClassInitialize() 
        {
            Authentication.Logon();
        }
        
        // Use ClassCleanup to run code after all tests in a class have run
        [TestFixtureTearDown]
        public static void MyClassCleanup()
        {
            Authentication.Logoff();
        }
        
        // Use TestInitialize to run code before running each test 
        [SetUp]
        public void MyTestInitialize() { }
        
        // Use TestCleanup to run code after each test has run
        [TearDown]
        public void MyTestCleanup() { }
        
        #endregion

        #region Test Methods

        [Test]
        public void GetCOEList()
        {
            PersonList thePersonList = PersonList.GetCOEList();
            Assert.IsNotNull(thePersonList);
        }

        [Test]
        public void InvalidateCache()
        {
            PersonList thePersonList = PersonList.GetCOEList();
            PersonList.InvalidateCache();
            Microsoft.VisualStudio.TestTools.UnitTesting.PrivateObject thePrivateObject =new Microsoft.VisualStudio.TestTools.UnitTesting.PrivateObject(thePersonList);
            object theNewPersonList = thePrivateObject.GetField("_list", BindingFlags.NonPublic | BindingFlags.Static);
            Assert.IsNull(theNewPersonList);
        }

        [Test]
        public void Remove()
        {
            PersonList thePersonList = PersonList.GetCOEList();
            int intCount= thePersonList.Count;
            if (SecurityHelper.GetUserDetails())
            {
                thePersonList.Remove(SecurityHelper.intPersonId);
                Assert.AreEqual(intCount - 1, thePersonList.Count);
            }
            else
                Assert.Fail("User does not exist");
        }

        #endregion Test Methods

    }
}