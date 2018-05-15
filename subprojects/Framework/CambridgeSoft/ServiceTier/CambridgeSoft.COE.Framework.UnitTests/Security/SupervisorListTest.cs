﻿using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CambridgeSoft.COE.Framework.COESecurityService;
using System.Reflection;

namespace CambridgeSoft.COE.Framework.UnitTests.Security
{
    /// <summary>
    /// Summary description for SupervisorListTest
    /// </summary>
    [TestClass]
    public class SupervisorListTest
    {
        public SupervisorListTest()
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
        [ClassInitialize()]
        public static void MyClassInitialize(TestContext testContext) { }
        
        // Use ClassCleanup to run code after all tests in a class have run
        [ClassCleanup()]
        public static void MyClassCleanup() { }
        
        // Use TestInitialize to run code before running each test 
        [TestInitialize()]
        public void MyTestInitialize() { }
        
        // Use TestCleanup to run code after each test has run
        [TestCleanup()]
        public void MyTestCleanup() { }
        
        #endregion

        #region Test Methods

        [TestMethod]
        public void GetList()
        {
            SupervisorList theSupervisorList = SupervisorList.GetList();
            Assert.IsNotNull(theSupervisorList);
        }

        [TestMethod]
        public void InvalidateCache()
        {
            SupervisorList theSupervisorList = SupervisorList.GetList();
            SupervisorList.InvalidateCache();
            PrivateObject thePrivateObject = new PrivateObject(theSupervisorList);
            object theNewSupervisorList = thePrivateObject.GetField("_list", BindingFlags.NonPublic | BindingFlags.Static);
            Assert.IsNull(theNewSupervisorList);
        }

        #endregion Test Methods

    }
}