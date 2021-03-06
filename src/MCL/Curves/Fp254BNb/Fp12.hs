{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnliftedFFITypes #-}
module MCL.Curves.Fp254BNb.Fp12
  ( Fp12
  , beta
  , mkFp12
  , fp12_c0
  , fp12_c1
  , fp12_c2
  , fp12_c3
  , fp12_c4
  , fp12_c5
  , fp12_isZero
  ) where

import Control.DeepSeq
import Data.Binary
import Foreign.C.Types

import MCL.Curves.Fp254BNb.Fp2
import qualified MCL.Internal.Field as I
import qualified MCL.Internal.Prim as I

-- | Sixth degree field extension of 'Fp2' defined as @Fp2(β)@, where @β⁶ = 1 + α@.
data Fp12 = Fp12 { unFp12 :: I.CC Fp12 }

instance Binary Fp12 where
  put n = put (fp12_c0 n) *> put (fp12_c1 n) *> put (fp12_c2 n)
       *> put (fp12_c3 n) *> put (fp12_c4 n) *> put (fp12_c5 n)
  get = mkFp12 <$> get <*> get <*> get <*> get <*> get <*> get

instance NFData Fp12 where
  rnf = (`seq` ())

instance Num Fp12 where
  (+)           = I.addFp
  (-)           = I.subtractFp
  (*)           = I.multiplyFp
  negate        = I.negateFp
  abs           = I.absFp
  signum        = I.signumFp
  fromInteger n = mkFp12 (fromInteger n) 0 0 0 0 0

instance Fractional Fp12 where
  recip        = I.recipFp
  fromRational = I.fromRationalFp

instance Eq Fp12 where
  (==) = I.eqFp

instance Show Fp12 where
  showsPrec p a = showsPrec p (fp12_c0 a, fp12_c1 a, fp12_c2 a,
                               fp12_c3 a, fp12_c4 a, fp12_c5 a)

-- | Root of the polynomial @x⁶ - 1 - α@.
{-# NOINLINE beta #-}
beta :: Fp12
beta = mkFp12 0 0 0 1 0 0

-- Construct an element of Fp12 from six coordinates in Fp2.
{-# INLINE mkFp12 #-}
mkFp12 :: Fp2 -> Fp2 -> Fp2 -> Fp2 -> Fp2 -> Fp2 -> Fp12
mkFp12 = I.unsafeOp6_ c_mcl_fp254bnb_fp12_from_base

-- | Return first Fp2 coordinate of the element in Fp12.
{-# INLINE fp12_c0 #-}
fp12_c0 :: Fp12 -> Fp2
fp12_c0 = I.unsafeOp1_ c_mcl_fp254bnb_fp12_c0

-- | Return second Fp2 coordinate of the element in Fp12.
{-# INLINE fp12_c1 #-}
fp12_c1 :: Fp12 -> Fp2
fp12_c1 = I.unsafeOp1_ c_mcl_fp254bnb_fp12_c1

-- | Return third Fp2 coordinate of the element in Fp12.
{-# INLINE fp12_c2 #-}
fp12_c2 :: Fp12 -> Fp2
fp12_c2 = I.unsafeOp1_ c_mcl_fp254bnb_fp12_c2

-- | Return fourth Fp2 coordinate of the element in Fp12.
{-# INLINE fp12_c3 #-}
fp12_c3 :: Fp12 -> Fp2
fp12_c3 = I.unsafeOp1_ c_mcl_fp254bnb_fp12_c3

-- | Return fifth Fp2 coordinate of the element in Fp12.
{-# INLINE fp12_c4 #-}
fp12_c4 :: Fp12 -> Fp2
fp12_c4 = I.unsafeOp1_ c_mcl_fp254bnb_fp12_c4

-- | Return sixth Fp2 coordinate of the element in Fp12.
{-# INLINE fp12_c5 #-}
fp12_c5 :: Fp12 -> Fp2
fp12_c5 = I.unsafeOp1_ c_mcl_fp254bnb_fp12_c5

-- | Check whether the element of Fp12 is zero.
{-# INLINE fp12_isZero #-}
fp12_isZero :: Fp12 -> Bool
fp12_isZero = I.isZero

----------------------------------------

-- | Internal
instance I.Prim Fp12 where
  prim_size _ = fromIntegral c_mcl_fp254bnb_fp12_size
  prim_wrap   = Fp12
  prim_unwrap = unFp12

-- | Internal
instance I.HasArith Fp12 where
  c_add      _ = c_mcl_fp254bnb_fp12_add
  c_subtract _ = c_mcl_fp254bnb_fp12_subtract
  c_multiply _ = c_mcl_fp254bnb_fp12_multiply
  c_negate   _ = c_mcl_fp254bnb_fp12_negate
  c_invert   _ = c_mcl_fp254bnb_fp12_invert
  c_eq       _ = c_mcl_fp254bnb_fp12_eq
  c_is_zero  _ = c_mcl_fp254bnb_fp12_is_zero

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_size"
  c_mcl_fp254bnb_fp12_size :: CInt

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_add"
  c_mcl_fp254bnb_fp12_add :: I.CC Fp12 -> I.CC Fp12 -> I.MC Fp12 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_subtract"
  c_mcl_fp254bnb_fp12_subtract :: I.CC Fp12 -> I.CC Fp12 -> I.MC Fp12 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_multiply"
  c_mcl_fp254bnb_fp12_multiply :: I.CC Fp12 -> I.CC Fp12 -> I.MC Fp12 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_negate"
  c_mcl_fp254bnb_fp12_negate :: I.CC Fp12 -> I.MC Fp12 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_from_base"
  c_mcl_fp254bnb_fp12_from_base :: I.CC Fp2 -> I.CC Fp2 -> I.CC Fp2
                                -> I.CC Fp2 -> I.CC Fp2 -> I.CC Fp2
                                -> I.MC Fp12 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_invert"
  c_mcl_fp254bnb_fp12_invert :: I.CC Fp12 -> I.MC Fp12 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_eq"
  c_mcl_fp254bnb_fp12_eq :: I.CC Fp12 -> I.CC Fp12 -> IO CInt

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_c0"
  c_mcl_fp254bnb_fp12_c0 :: I.CC Fp12 -> I.MC Fp2 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_c1"
  c_mcl_fp254bnb_fp12_c1 :: I.CC Fp12 -> I.MC Fp2 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_c2"
  c_mcl_fp254bnb_fp12_c2 :: I.CC Fp12 -> I.MC Fp2 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_c3"
  c_mcl_fp254bnb_fp12_c3 :: I.CC Fp12 -> I.MC Fp2 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_c4"
  c_mcl_fp254bnb_fp12_c4 :: I.CC Fp12 -> I.MC Fp2 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_c5"
  c_mcl_fp254bnb_fp12_c5 :: I.CC Fp12 -> I.MC Fp2 -> IO ()

foreign import ccall unsafe "hs_mcl_fp254bnb_fp12_is_zero"
  c_mcl_fp254bnb_fp12_is_zero :: I.CC Fp12 -> IO CInt
