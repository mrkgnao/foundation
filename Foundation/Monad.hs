{-# LANGUAGE CPP #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE StandaloneDeriving #-}
module Foundation.Monad
    ( MonadIO(..)
    , MonadFailure(..)
    , MonadThrow(..)
    , MonadCatch(..)
    , MonadBracket(..)
    , MonadTrans(..)
    , Identity(..)
    ) where

import Foundation.Monad.MonadIO
import Foundation.Monad.Exception
import Foundation.Monad.Transformer

#if MIN_VERSION_base(4,8,0)
import Data.Functor.Identity

#else

import Control.Monad.Fix
import Control.Monad.Zip
import Foundation.Internal.Base

#if MIN_VERSION_base(4,6,0)
import GHC.Generics (Generic1)
#endif

-- | Identity functor and monad. (a non-strict monad)
--
-- @since 4.8.0.0
newtype Identity a = Identity { runIdentity :: a }
    deriving (Eq, Ord, Data, Generic, Typeable)

#if MIN_VERSION_base(4,6,0)
deriving instance Generic1 Identity
#endif

instance Functor Identity where
    fmap f (Identity x) = Identity (f x)

instance Applicative Identity where
    pure     = Identity
    Identity f <*> Identity x = Identity (f x)

instance Monad Identity where
    return   = Identity
    m >>= k  = k (runIdentity m)

instance MonadFix Identity where
    mfix f   = Identity (fix (runIdentity . f))

instance MonadZip Identity where
    mzipWith f (Identity x) (Identity y) = Identity (f x y)
    munzip (Identity (x, y)) = (Identity x, Identity y)

#endif
